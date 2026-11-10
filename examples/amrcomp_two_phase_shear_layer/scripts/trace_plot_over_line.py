# trace generated using paraview version 6.1.1
#import paraview
#paraview.compatibility.major = 6
#paraview.compatibility.minor = 1

#### import the simple module from the paraview
from paraview.simple import *
#### disable automatic camera reset on 'Show'
paraview.simple._DisableFirstRenderCameraReset()

# create a new 'AMReX/BoxLib Grid Reader'
pltnga2cell000001 = AMReXBoxLibGridReader(registrationName='plt.nga2.cell.000001*', FileNames=['/home/zmiller4/NGA2_all/Simulations/sims8-27-2026/amrcomp_two_phase_shear_layer/saved_simulations/average_cell_velocity_first_try/amrviz/drop/plt.nga2.cell.000001', '/home/zmiller4/NGA2_all/Simulations/sims8-27-2026/amrcomp_two_phase_shear_layer/saved_simulations/average_cell_velocity_first_try/amrviz/drop/plt.nga2.cell.000002'])

# get animation scene
animationScene1 = GetAnimationScene()

# update animation scene based on data timesteps
animationScene1.UpdateAnimationUsingDataTimeSteps()

# Properties modified on pltnga2cell000001
pltnga2cell000001.Set(
    Level=27,
    CellArrayStatus=['U'],
)

# get active view
renderView1 = GetActiveViewOrCreate('RenderView')

# show data in view
pltnga2cell000001Display = Show(pltnga2cell000001, renderView1, 'AMRRepresentation')

# trace defaults for the display properties.
pltnga2cell000001Display.Representation = 'Outline'

# reset view to fit data
renderView1.ResetCamera(False, 0.9)

# get the material library
materialLibrary1 = GetMaterialLibrary()

# update the view to ensure updated data information
renderView1.Update()

# change representation type
pltnga2cell000001Display.SetRepresentationType('Surface')

# set scalar coloring
ColorBy(pltnga2cell000001Display, ('CELLS', 'U'))

# rescale color and/or opacity maps used to include current data range
pltnga2cell000001Display.RescaleTransferFunctionToDataRange(True, False)

# show color bar/color legend
pltnga2cell000001Display.SetScalarBarVisibility(renderView1, True)

# get color transfer function/color map for 'U'
uLUT = GetColorTransferFunction('U')

# get opacity transfer function/opacity map for 'U'
uPWF = GetOpacityTransferFunction('U')

# get 2D transfer function for 'U'
uTF2D = GetTransferFunction2D('U')

# create a new 'Plot Over Line'
plotOverLine1 = PlotOverLine(registrationName='PlotOverLine1', Input=pltnga2cell000001)

# Properties modified on plotOverLine1
plotOverLine1.Set(
    SamplingPattern='Sample At Segment Centers',
    Point1=[0.09375, -6.0, 0.09375],
    Point2=[0.09375, 6.0, 0.09375],
)

# show data in view
plotOverLine1Display = Show(plotOverLine1, renderView1, 'GeometryRepresentation')

# trace defaults for the display properties.
plotOverLine1Display.Representation = 'Surface'

# Create a new 'Line Chart View'
lineChartView1 = CreateView('XYChartView')

# show data in view
plotOverLine1Display_1 = Show(plotOverLine1, lineChartView1, 'XYChartRepresentation')

# get layout
layout1 = GetLayoutByName("Layout #1")

# add view to a layout so it's visible in UI
AssignViewToLayout(view=lineChartView1, layout=layout1, hint=0)

# Properties modified on plotOverLine1Display_1
plotOverLine1Display_1.SeriesOpacity = ['Points_Magnitude', '1', 'Points_X', '1', 'Points_Y', '1', 'Points_Z', '1', 'U', '1', 'arc_length', '1', 'vtkGhostType', '1', 'vtkValidPointMask', '1']

# update the view to ensure updated data information
lineChartView1.Update()

# Rescale transfer function
uLUT.RescaleTransferFunction(-22.225444877437315, 22.44994432064354)

# Rescale transfer function
uPWF.RescaleTransferFunction(-22.225444877437315, 22.44994432064354)

# save data
SaveData('/home/zmiller4/NGA2_all/Simulations/sims8-27-2026/amrcomp_two_phase_shear_layer/saved_simulations/trace_practice.csv', proxy=plotOverLine1, PointDataArrays=['U', 'arc_length', 'vtkGhostType', 'vtkValidPointMask'],
    Precision=15)

#================================================================
# addendum: following script captures some of the application
# state to faithfully reproduce the visualization during playback
#================================================================

#--------------------------------
# saving layout sizes for layouts

# layout/tab size in pixels
layout1.SetSize(1388, 717)

#-----------------------------------
# saving camera placements for views

# current camera placement for renderView1
renderView1.Set(
    CameraPosition=[0.0, 0.0, 32.78661064353924],
    CameraParallelScale=8.485799258908969,
)


##--------------------------------------------
## You may need to add some code at the end of this python script depending on your usage, eg:
#
## Render all views to see them appears
# RenderAllViews()
#
## Interact with the view, usefull when running from pvpython
# Interact()
#
## Save a screenshot of the active view
# SaveScreenshot("path/to/screenshot.png")
#
## Save a screenshot of a layout (multiple splitted view)
# SaveScreenshot("path/to/screenshot.png", GetLayout())
#
## Save all "Extractors" from the pipeline browser
# SaveExtracts()
#
## Save a animation of the current active view
# SaveAnimation()
#
## Please refer to the documentation of paraview.simple
## https://www.paraview.org/paraview-docs/nightly/python/
##--------------------------------------------