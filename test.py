try:
    import deeplabcut as dlc
except ModuleNotFoundError:
    import deeplabcutcore as dlc
import tensorflow as tf
print(f"Loaded DeepLabCut {dlc.__version__} for Tensorflow {tf.__version__}")