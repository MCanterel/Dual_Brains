# Dual Brains

Real-time visual performance driven by the brain data of two performers.  
https://artahack.io/projects/dual-brains/

## Running Dual_Brains_Visualization

 - Download and install [Processing](https://processing.org/)
 - Download [hypermedia](https://ubaa.net/shared/processing/udp/)'s' Processing library and unzip it into the Processing/Libraries folder.
 - Open `Dual_Brains_Visualization/Dual_Brains_Visualization.pde` in Processing and press ▶️.

## Sending data from OpenBCI to Dual_Brains_Visualization

You will need to have Python 2.7 installed (locally or in a virtual env) and some dependencies:
  - serial
  - numpy
  - scipy

Run this command to install all dependencies at once:

```pip install -r requirements.txt```

If you have an OpenBCI connected to the computer, you can stream the data to the visualization like this:

```python python/data_buffer.py --serial-port /path/to/the/serial/port```

If you don't an OpenBCI connected, you can stream pre-recorded test data to the visualization like this:

```python python/data_buffer.py --test-file /path/to/test/file.txt```

_Different test files are provided in the `aaron_test_data` folder_

## Contributors
 - [Eva Lee](http://www.evaleestudio.com/), Artist & Experimental Filmmaker
 - [Gabriel Ibagon](https://github.com/gabrielibagon), Programmer & Artist
 - [Gal Nissim](https://www.galnissim.com/), ScienArtist
 - [Pat Shiu](http://patshiu.com/), Visual Artist
 - [Aaron Trocola](http://threeformfashion.com/), 3D Fashion Designer
 - [Julien Deswaef](https://xuv.be), Artist & Technologist
