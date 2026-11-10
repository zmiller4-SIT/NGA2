# plot_over_line.py
# Opens one AMReX plotfile, places a vertical line at the cell center in x and z
# (x = dx/2, z = dz/2) running the full domain height in y, samples at segment
# (cell) centers, and saves a full-precision CSV.
#
# Run:  pvpython611 plot_over_line.py

from paraview.simple import *

# ======================= inputs =======================
plotfile = ('/home/zmiller4/NGA2_all/Simulations/sims8-27-2026/amrcomp_two_phase_shear_layer/'
            'amrviz/drop/plt.nga2.cell.000001')
out_dir  = '/home/zmiller4/NGA2_all/Simulations/sims8-27-2026/amrcomp_two_phase_shear_layer/saved_simulations'
tag      = 'cell_average'      # label for this run, used in the CSV name
level    = 0                   # AMR level whose cell size sets the line position
# ======================================================


def read_amrex_cell_size(plotfile, level=0):
    """Return [dx, dy, dz], domain lo, domain hi from the plotfile's Header (plain text)."""
    with open(plotfile + '/Header') as f:
        lines = [line.strip() for line in f]
    nvars  = int(lines[1])
    i      = 2 + nvars              # skip version line, nvars line, variable names
    finest = int(lines[i + 2])
    lo = [float(v) for v in lines[i + 3].split()]
    hi = [float(v) for v in lines[i + 4].split()]
    if level > finest:
        raise ValueError(f'level {level} requested, plotfile finest level is {finest}')
    # then: ref ratio line, domain boxes line, level steps line, one cell-size line per level
    d = [float(v) for v in lines[i + 8 + level].split()]
    return d, lo, hi


# ---- grid info from the plotfile header ----
(dx, dy, dz), lo, hi = read_amrex_cell_size(plotfile, level)
ymin, ymax = lo[1], hi[1]
nyc = round((ymax - ymin) / dy)
print(f'domain y: [{ymin}, {ymax}],  dx = {dx},  dy = {dy},  dz = {dz},  cells in y = {nyc}')

# ---- open the plotfile ----
src = AMReXBoxLibGridReader(FileNames=[plotfile])
src.Level = 27                 # max level to load (value from your trace)
src.CellArrayStatus = ['U']
src.UpdatePipeline()

# ---- plot over line at the cell center in x and z ----
pol = PlotOverLine(Input=src)
pol.SamplingPattern = 'Sample At Segment Centers'
pol.Point1 = [dx/2, ymin, dz/2]
pol.Point2 = [dx/2, ymax, dz/2]
pol.UpdatePipeline()

# ---- save CSV at full double precision ----
outfile = f'{out_dir}/plot_over_line_{tag}_ny{nyc}.csv'
SaveData(outfile, proxy=pol,
         PointDataArrays=['U', 'arc_length', 'vtkGhostType', 'vtkValidPointMask'],
         Precision=17,
         UseScientificNotation=1)
print('saved', outfile)
