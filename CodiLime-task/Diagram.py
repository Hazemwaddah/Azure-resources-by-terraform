from diagrams import Diagram
from diagrams.azure.compute import VM

with Diagram("Simple Diagram"):
    VM("web")


