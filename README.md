# Floor Map with Access Point Localization

- This MATLAB project visualizes a floor map and simulates user localization based on received signal power from multiple access points (APs). 
- The script uses signal strength measurements and path loss models to estimate the user's position within a defined floor plan.

## Features

- **Floor Map Visualization**: Draws a detailed floor map with walls and access points.
- **Signal Strength Calculation**: Simulates signal strength from access points to various reference points on the floor map.
- **User Localization**: Estimates user position based on input signal strengths from multiple access points.



### Prerequisites

- MATLAB R2019b or later.
- Basic understanding of MATLAB scripting and plotting.

### Running the Script

1. Clone the repository or download the script file.
2. Open MATLAB and navigate to the folder containing the script.
3. Run the script by typing the script name in the MATLAB command window.

### Script Breakdown

- **Wall Initialization**: Defines the position and dimensions of walls on the floor plan.
- **Access Point Setup**: Specifies the location and dimensions of access points.
- **Reference Point Calculation**: Generates a grid of points across the floor for localization.
- **Power Calculation**: Computes the received power at each reference point from each access point.
- **User Input and Localization**: Prompts for user input of received power values and calculates the estimated position.

## Example Usage

Run the script in MATLAB, and you will see:
- A floor map displaying walls and access points.
- Power heatmaps for each access point.
- An estimated user location based on the input received power values.

## Contributing

Feel free to submit issues or pull requests if you find any bugs or want to add new features.



