# minimum-bounding-box

A Matlab function that calculates the minimum bounding box in a R^N Cartesian space.
The bounding box is defined by the 2N hyperplanes equations. 
The code uses the Singular Value Decomposition (SVD) to compute the principal axes.

A demo is provided to show how to interface with the function and visualizing the sample data.
Note that the demo script has a fixed random seed for replicability by the user.  

#### Demo Images

<img src="img/fig1-data-points.png" width="250">
*Figure 1*
 
<img src="img/fig2-data-points-pricipal-axis.png" width="250">
*Figure 2*

<img src="img/fig3-data-points-in-bounding-box-reference-frame.png" width="250">
*Figure 3*

<img src="img/fig4-data-points-bounding-planes.png" width="250">
*Figure 4*
