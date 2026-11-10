
# run with following command to avoid vtk pop-up 
# pvpython611 --force-offscreen-rendering paraview_make_video_2.py


# paraview_make_video.py   run with:  pvpython611 paraview_make_video.py
from paraview.simple import *
import glob, os, shutil, subprocess

# ---- settings ----
STATE_FILE = "VideoMake_PL.pvsm"
FRAME_DIR  = "frames"
MOVIE_NAME = "movie.mp4"
FPS        = 24
RESOLUTION = [1920, 1080]
# ------------------

# start with an empty frames folder so old frames don't end up in the video
if os.path.isdir(FRAME_DIR):
    shutil.rmtree(FRAME_DIR)
os.makedirs(FRAME_DIR)

# render frames
LoadState(STATE_FILE)
view = GetActiveViewOrCreate("RenderView")

scene = GetAnimationScene()
scene.UpdateAnimationUsingDataTimeSteps()

SaveAnimation(f"{FRAME_DIR}/frame.png", view, ImageResolution=RESOLUTION)

n_frames = len(glob.glob(f"{FRAME_DIR}/frame.*.png"))
print(f"Rendered {n_frames} frames")

# stitch into a video
subprocess.run([
    "ffmpeg", "-y",                      # -y: overwrite movie.mp4 if it exists
    "-framerate", str(FPS),
    "-i", f"{FRAME_DIR}/frame.%04d.png",
    "-c:v", "libx264", "-pix_fmt", "yuv420p", "-crf", "18",
    MOVIE_NAME,
], check=True)

print(f"Done: {os.path.abspath(MOVIE_NAME)}")

shutil.rmtree(FRAME_DIR)   # delete frames once the movie is made
print("Deleted frames folder")
