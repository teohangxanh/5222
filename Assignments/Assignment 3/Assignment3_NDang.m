clc; clear all; close all;
image_path = 'D:\BitBucket\5222\Assignments\Assignment 3\guns.jpg';
%% Task 1: 
% read an image into the workspace
img = imread(image_path);
%% Task 4: 
% Apply this function to the image to detect lines. (15 points)
lines = func_1(image_path, 40);
lines2 = func_2(image_path, 2, 40);
%% Task 5b:
% visualize the detected lines (15 points)
lines2vis(image_path, lines);
% lines2vis(image_path, lines2);
%% Task 2:
% develop a function to perform Hough transform that can detect straight
% lines of at least a certain length. The length is an input argument 
% to the line detection function. (25 points)
% Reference: https://www.mathworks.com/help/images/hough-transform.html
function lines = func_1(inp_file, least_length)
    %     Read image
    img = imread(inp_file);
    % Convert to grayscale if colored
    if size(img, 3) > 1
        img = rgb2gray(img);
    end
    %     Find the edges in the image using the edge function.
    BW = edge(img,'canny');
    imshowpair(img, BW, 'montage');
    %     Compute the Hough transform of the binary image returned by edge.
    [H,theta,rho] = hough(BW);
%     Find the peaks in the Hough transform matrix, H, using the houghpeaks function.
    P = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
    x = theta(P(:,2));
    y = rho(P(:,1));
%     Find lines in the image using the houghlines function.
    lines = houghlines(BW,theta,rho,P,'FillGap',5,'MinLength',least_length);
end

%% Task 3: 
% Extend the above function to include an argument of line width so that
% the new function detects straight lines of given width and length
% (the width and length are input arguments of the function. (25 points)
function wide_lines = func_2(inp_file, least_width, least_length)
    function t = extract_width(lines, least_width)
        % Return a struct of lines that are at least as wide as least_width
        % Get table form
        t = struct2table(lines);
        % Create new columns
        t.x1 = t.point1(:,1);
        t.y1 = t.point1(:,2);
        t.x2 = t.point2(:,1);
        t.y2 = t.point2(:,2);
        t = t(:,end-5:end);
        t.width_to_leftside = t.x1(:,1) * 0 + 1;
        % Sort the table based on x1
        [t, index] = sortrows(t, 3, 'ascend');
        % Count to the right
        for ii=2:size(t,1)
            xi1 = t{ii,'x1'};
            yi1 = t{ii,'y1'};
            xi2 = t{ii,'x2'};
            yi2 = t{ii,'y2'};
            xj1 = t{ii-1,'x1'};
            yj1 = t{ii-1,'y1'};
            xj2 = t{ii-1,'x2'};
            yj2 = t{ii-1,'y2'};
            if and(xi1 - 1 == xj1 & xi2 - 1 == xj2, ...
                    yi1 == yj1 & yi2 == yj2)
                disp(xi1)
                t{ii,'width_to_leftside'} = t{ii-1,'width_to_leftside'} + 1;
            else
                t{ii,'width_to_leftside'} = 0;
            end
        end
        %     Delete rows that count < least_width
        t = t{find(t.width_to_leftside >= least_width), :}
    end
    lines = func_1(inp_file, least_length);
    wide_lines = extract_width(lines, least_width);
end
%% Task 5a:
% Function to visualize lines
function visualization = lines2vis(image_path, lines)
    parts = strsplit(image_path,'\');
    img = imread(image_path);
    % Convert to grayscale if colored
    if size(img, 3) > 1
        img = rgb2gray(img);
    end
%     Create a plot that displays the original image with the lines superimposed on it.
    figure, imshow(img), hold on
    max_len = 0;
    for k = 1:length(lines)
        xy = [lines(k).point1; lines(k).point2];
        plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
        
        % Plot beginnings and ends of lines
        plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
        plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
        
        % Determine the endpoints of the longest line segment
        len = norm(lines(k).point1 - lines(k).point2);
        if ( len > max_len)
          max_len = len;
          xy_long = xy;
        end
    end
%     highlight the longest line segment
    plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');
end