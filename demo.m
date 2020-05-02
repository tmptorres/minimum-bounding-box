%% Create sample data
% For this example lets say they are RGB colors

rng(1234);

N = 5000;       % Number of points
A = randn(3,N); % Normal distributed 3D data points

[U,~,V] = svd(A);
d = [1,.25,.66];  % Distortion factors
d = d/norm(d);
S = horzcat( diag(d), zeros(3,N-3) );

colorsRGB = U*S*V';      % Apply distortion to data

% Apply an extra affine transformation to data to make shure algorithm
% works well with non-centered data
colorsRGB = round(1000*colorsRGB + 500);

% Plot data points
figure(1);
plot3(colorsRGB(1,:), colorsRGB(2,:), colorsRGB(3,:), '.');
grid on; axis equal;
title('RGB data points');
xlabel('x'); ylabel('y'); zlabel('z');
print('./img/fig1-data-points', '-dpng', '-r300');

%% Process data
[ planeEqs, U, meanColorsRGB ] = minimumBoundingBox( colorsRGB );

%% Test computed boundaries
for i = 1:size(planeEqs,1)
    for j = 1:size(colorsRGB,2)
        
        if( planeEqs{i,1}(1:end-1)'*colorsRGB(:,i) + planeEqs{i,1}(end) < 0 )
            error(['Error: Point %d is under the lower plane in the %d-th'...
                ' dimension\n'], j, i);
        end
        
        if( planeEqs{i,2}(1:end-1)'*colorsRGB(:,i) + planeEqs{i,2}(end) > 0 )
            error(['Error: Point %d is over the upper plane in the %d-th'...
                ' dimension\n'], j, i);
        end
         
    end
end

%% Plot of the data and bounding planes

% Plot data and its principal axis
figure(2);
% Plot the original data
plot3(colorsRGB(1,:), colorsRGB(2,:), colorsRGB(3,:), '.');
grid on; axis equal;

% Plot the principal axis
colorsRGBaux = inv(U)*(colorsRGB - meanColorsRGB);
range = [min(colorsRGBaux,[],2), max(colorsRGBaux,[],2)];
dR = diff(range,1,2)/2;
mC = meanColorsRGB;

hold on;
plot3([0 U(1,1)*dR(1)]+mC(1), [0 U(2,1)*dR(1)]+mC(2), [0 U(3,1)*dR(1)]+mC(3), 'r');
plot3([0 U(1,2)*dR(2)]+mC(1), [0 U(2,2)*dR(2)]+mC(2), [0 U(3,2)*dR(2)]+mC(3), 'g');
plot3([0 U(1,3)*dR(3)]+mC(1), [0 U(2,3)*dR(3)]+mC(2), [0 U(3,3)*dR(3)]+mC(3), 'c');
hold off;
xlabel('x'); ylabel('y'); zlabel('z');
title('Data and its principal axis');
print('./img/fig2-data-points-pricipal-axis', '-dpng', '-r300');


% Plot the data inside the bounding box reference frame
figure(3);
colorsRGBaux = inv(U)*(colorsRGB - meanColorsRGB);

plot3(colorsRGBaux(1,:), colorsRGBaux(2,:), colorsRGBaux(3,:), '.');
grid on; axis equal;
xlabel('x'); ylabel('y'); zlabel('z');
title('Data in the bounding box reference frame');
print('./img/fig3-data-points-in-bounding-box-reference-frame', '-dpng', '-r300');


% Data and its bounding planes
figure(4);
plot3(colorsRGB(1,:), colorsRGB(2,:), colorsRGB(3,:), '.');
grid on; axis equal;

range = [min(colorsRGB,[],2), max(colorsRGB,[],2)];

hold on;
for i = 1:size(planeEqs,1)
    for j = 1:size(planeEqs,2)
        % Generate x and y data
        [x, y] = meshgrid( range(1,1):range(1,2) , range(2,1):range(2,2) );
        % Solve for z data
        z = -1/planeEqs{i,j}(3)*(planeEqs{i,j}(1)*x + planeEqs{i,j}(2)*y + planeEqs{i,j}(4));
        %Plot the surface
        surf(x,y,z, 'FaceColor',[.5,.5,.5], 'FaceAlpha', .3, 'LineStyle', 'none');
    end
end
hold off;
xlabel('x'); ylabel('y'); zlabel('z');
title('Data and its bounding planes');
print('./img/fig4-data-points-bounding-planes', '-dpng', '-r300');
