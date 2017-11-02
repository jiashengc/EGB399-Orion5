function plswork2(inputImg, gamma, thresh, claw)
%Function inputs: ('filename.ext', gamma, threshold).  

%% Use predefined inputs if they are not supplied
    if ~exist('im','var')
        inputImg = 'prac2.jpg'; 
    end

    if ~exist('gamma','var')
        gamma = 2; 
    end
    
    if ~exist('thresh','var')
        thresh = 0.5; 
    end

%% Setup custom program varibles
    inputImg = imread(inputImg);
    
    %Variables.
    minBlobArea = 2000;
    maxBlobArea = 1000000;
   Q = [20 20; 290 20; 560 20; 20 182.5; 290 182.5; 560 182.5; 20 345; 290 345; 560 345];

    circC = 0.91;  circS = 0.74;  circT = 0.55;

    %%Get planes of colour image, Normalise and Gamma Correction.  
    im = (double(inputImg)/255).^gamma;
    
    %Chromacity.
    avg = im(:, :, 1) + im(:, :, 2) + im(:, :, 3);
    r1 = im(:, :, 1) ./ avg;
    g1 = im(:, :, 2) ./ avg;
    b1 = im(:, :, 3) ./ avg;
    
    %Thresholding.
    r = r1 > thresh;
    g = g1 > thresh;
    b = b1 > thresh;
    
    %Blue Blobs
    blueBlobs = iblobs(b, 'area', [minBlobArea, maxBlobArea], 'boundary');
    
    %Trim images
    cutLineTop = min(blueBlobs.vmin);
    cutLineBottom = max(blueBlobs.vmax);
    
    cutR = r(cutLineTop:cutLineBottom, :);
    cutG = g(cutLineTop:cutLineBottom, :);
    cutB = b(cutLineTop:cutLineBottom, :);
    
    inputImg = inputImg(cutLineTop:cutLineBottom, :, :);
    
    %Create search images
    findR = r(1:cutLineTop,:);
    findG = g(1:cutLineTop,:);
    
    %Create RGB blobs
    redBlobs = iblobs(cutR, 'area', [minBlobArea, maxBlobArea], 'boundary');
    greenBlobs = iblobs(cutG, 'area', [minBlobArea, maxBlobArea], 'boundary');
    blueBlobs = iblobs(cutB, 'area', [minBlobArea, maxBlobArea], 'boundary');
    
    %Create red and green search blobs
    findBr = iblobs(findR, 'area', [minBlobArea, maxBlobArea], 'boundary');
    findBg = iblobs(findG, 'area', [minBlobArea, maxBlobArea], 'boundary');    
    
    %% Circularity for RED.
    numberRedCircle = 0;
    numberRedSquare = 0;
    numberRedTriangle = 0;
    
    numberOfShapes = length(redBlobs);
    foundCircle = zeros(numberOfShapes, 3);
    foundSquare = zeros(numberOfShapes, 3);
    foundTriangle = zeros(numberOfShapes, 3);
    
    red = 1;
    green = 2;
   
    strC = string(); sizeC = 0;
    strS = string(); sizeS = 0;
    strT = string(); sizeT = 0;
    
    for i=1:length(redBlobs)
%         disStuff = strcat(num2str(i), ') ');
        if redBlobs(i).circularity > circC
            foundCircle(size(foundCircle,1)+1,1:3) = [i, redBlobs(i).area, red]; 
                sizeC = sizeC + 1; 
                strC(sizeC, 1) = ['(', num2str(redBlobs(i).uc), ', ', num2str(redBlobs(i).vc), ')'];
                strC(sizeC, 3) = 'red circle';
            numberRedCircle = numberRedCircle + 1;
%             disStuff = strcat(disStuff, ' Red circle, area: ', num2str(redBlobs(i).area));
%             disStuff = strcat(disStuff, ' Cent: ', num2str(redBlobs(i).uc), ', ', num2str(redBlobs(i).vc) );
            
        elseif redBlobs(i).circularity > circS
            foundSquare(size(foundSquare,1)+1,1:3) = [i, redBlobs(i).area, red]; 
            sizeS = sizeS + 1; 
                strS(sizeS, 1) = ['(', num2str(redBlobs(i).uc), ', ', num2str(redBlobs(i).vc), ')'];
                strS(sizeS, 3) = 'red square';
            numberRedSquare = numberRedSquare + 1;
%             disStuff = strcat(disStuff, ' Red square, area: ', num2str(redBlobs(i).area));
%             disStuff = strcat(disStuff, ' Cent: ', num2str(redBlobs(i).uc), ', ', num2str(redBlobs(i).vc) );
            
        elseif redBlobs(i).circularity > circT
            foundTriangle(size(foundTriangle,1)+1,1:3) = [i, redBlobs(i).area, red]; 
            sizeT = sizeT + 1; 
                strT(sizeT, 1) = ['(', num2str(redBlobs(i).uc), ', ', num2str(redBlobs(i).vc), ')'];
                strT(sizeT, 3) = 'red triangle';
            numberRedTriangle = numberRedTriangle + 1;
%             disStuff = strcat(disStuff, ' Red triangle, area: ', num2str(redBlobs(i).area)); 
%             disStuff = strcat(disStuff, ' Cent: ', num2str(redBlobs(i).uc), ', ', num2str(redBlobs(i).vc) );
        end
%        disp(disStuff);
    end 
    
    %% Circularity for GREEN.
    numberGreenCircle = 0;
    numberGreenSquare = 0;
    numberGreenTriangle = 0;
    
    numberOfShapes = length(greenBlobs);
    foundCircle = zeros(numberOfShapes, 3);
    foundSquare = zeros(numberOfShapes, 3);
    foundTriangle = zeros(numberOfShapes, 3);
        
    for i=1:length(greenBlobs)
%         disStuff = strcat(num2str(i), ') ');
        if greenBlobs(i).circularity > circC
            foundCircle(size(foundCircle,1)+1,1:3) = [i, greenBlobs(i).area, green];
            sizeC = sizeC + 1; 
                strC(sizeC, 1) = ['(', num2str(greenBlobs(i).uc), ', ', num2str(greenBlobs(i).vc), ')'];
                strC(sizeC, 3) = 'green circle';
            numberGreenCircle = numberGreenCircle + 1;
%             disStuff = strcat(disStuff, ' Green circle, area: ', num2str(greenBlobs(i).area), ' Cent: ', num2str(greenBlobs(i).uc), ', ', num2str(greenBlobs(i).vc) );
        elseif greenBlobs(i).circularity > circS
            foundSquare(size(foundSquare,1)+1,1:3) = [i, greenBlobs(i).area, green];
             sizeS = sizeS + 1; 
                strS(sizeS, 1) = ['(', num2str(greenBlobs(i).uc), ', ', num2str(greenBlobs(i).vc), ')'];
                strS(sizeS, 3) = 'green square';
            numberGreenSquare = numberGreenSquare + 1;
%             disStuff = strcat(disStuff, ' Green square, area: ', num2str(greenBlobs(i).area), ' Cent: ', num2str(greenBlobs(i).uc), ', ', num2str(greenBlobs(i).vc) );
        elseif greenBlobs(i).circularity > circT
            foundTriangle(size(foundTriangle,1)+1,1:3) = [i, greenBlobs(i).area, green]; 
            sizeT = sizeT + 1; 
                strT(sizeT, 1) = ['(', num2str(greenBlobs(i).uc), ', ', num2str(greenBlobs(i).vc), ')'];
                strT(sizeT, 3) = 'green triangle';
            numberGreenTriangle = numberGreenTriangle + 1;
%             disStuff = strcat(disStuff, ' Green triangle, area: ', num2str(greenBlobs(i).area), ' Cent: ', num2str(greenBlobs(i).uc), ', ', num2str(greenBlobs(i).vc) );
        end
       % disp(disStuff);
    end  
    
    %% Finding big and small triangles, squares and circles
    minSizeT = min(foundTriangle(:, 2));
    for i = 1:size(foundTriangle, 1)
       if (foundTriangle(i,2) / minSizeT) < 1.5
           foundTriangle(i,4) = 1;
           strT(i,2) = 'small';
       else
           foundTriangle(i,4) = 2;
           strT(i,2) = 'large';
       end
    end
    
    minSizeC = min(foundCircle(:, 2));
    for i = 1:size(foundCircle, 1)
       if (foundCircle(i,2) / minSizeC) < 1.5
           foundCircle(i,4) = 1;
           strC(i,2) = 'small';
       else
           foundCircle(i,4) = 2;
           strC(i,2) = 'large';
       end
    end
    
    minSizeS = min(foundSquare(:, 2));
    for i = 1:size(foundSquare, 1)
       if (foundSquare(i,2) / minSizeS) < 1.5
           foundSquare(i,4) = 1;
           strS(i,2) = 'small';
       else
           foundSquare(i,4) = 2;
           strS(i,2) = 'large';
       end
    end
    
    %% Finds the 3 search shapes
    
    targetBlobs = {};
	shapeBlobs = {};
    targetString = string();
    a = 0;
    
    for i=1:length(findBr)
       fb = findBr(i);
       for n=1:length(redBlobs)
           b = redBlobs(n);
           if (b.circularity > (fb.circularity * 0.85) && b.circularity < (fb.circularity * 1.1))
                if (b.area > (fb.area * 0.8) && b.area < (fb.area * 1.2))
                    targetBlobs = [targetBlobs b];
					fb2 = fb.uc; 
					shapeBlobs = [shapeBlobs fb2];
                    a = a + 1;
                    targetString(a, 2) = 'red';
                    if b.circularity > circC 
                        targetString(a, 3) = 'circle';
                        if (b.area/minSizeC) < 1.5
                            targetString(a, 1) = 'small';
                        else 
                            targetString(a, 1) = 'large';
                        end
                    elseif b.circularity > circS 
                        targetString(a, 3) = 'square';
                        if (b.area/minSizeS) < 1.5
                            targetString(a, 1) = 'small';
                        else 
                            targetString(a, 1) = 'large';
                        end
                    elseif b.circularity > circT
                        targetString(a, 3) = 'triangle';
                        if (b.area/minSizeT) < 1.5
                            targetString(a, 1) = 'small';
                        else 
                            targetString(a, 1) = 'large';
                        end
                    end
                    break;
                end
           end
       end
    end
    
    for i=1:length(findBg)
       fg = findBg(i);
       for n=1:length(greenBlobs)
           b = greenBlobs(n);
           if (b.circularity > (fg.circularity * 0.85) && b.circularity < (fg.circularity * 1.1))
                if (b.area > (fg.area * 0.8) && b.area < (fg.area * 1.2))
                    targetBlobs = [targetBlobs b];
					fg2 = fg.uc; 
					shapeBlobs = [shapeBlobs fg2];
                    a = a + 1;
                    targetString(a, 2) = 'green';
                     if b.circularity > circC 
                        targetString(a, 3) = 'circle';
                        if (b.area/minSizeC) < 1.5
                            targetString(a, 1) = 'small';
                        else 
                            targetString(a, 1) = 'large';
                        end
                    elseif b.circularity > circS 
                        targetString(a, 3) = 'square';
                        if (b.area/minSizeS) < 0.5
                            targetString(a, 1) = 'small';
                        else 
                            targetString(a, 1) = 'large';
                        end
                    elseif b.circularity > circT
                        targetString(a, 3) = 'triangle';
                        if (b.area/minSizeT) < 1.5
                            targetString(a, 1) = 'small';
                        else 
                            targetString(a, 1) = 'large';
                        end
                    end
                    break;
                end
           end
       end
    end  
	%%
	%Sort array in shape order. 
    matShapeBlobs = cell2mat(shapeBlobs);    
    
	for i = 1:length(matShapeBlobs)
		for j = 1:length(matShapeBlobs)-1
			if matShapeBlobs(j) > matShapeBlobs(j+1)
				temp = targetBlobs(j+1); 
                targetBlobs(j+1) = targetBlobs(j);
                targetBlobs(j) = temp;
                
                
				temp2 = matShapeBlobs(j+1);
				matShapeBlobs(j+1) = matShapeBlobs(j);
                matShapeBlobs(j) = temp2;
			end 
		end
	end 

    %% Sort and build Pb matrix
middleRow = (min(blueBlobs.vc) + max(blueBlobs.vc))/2;
middleColumn = (min(blueBlobs.uc) + max(blueBlobs.uc))/2;
Pb = zeros(2, 9);
originCoOrd = zeros(2,1);

for i = 1:length(blueBlobs)
    locationRow = blueBlobs(i).vc/middleRow;
    locationColumn = blueBlobs(i).uc/middleColumn;
    if (locationRow < 0.6)
        % build row 1
        if (locationColumn < 0.6)
            % left column
            Pb(1, 1) = blueBlobs(i).uc;
            Pb(2, 1) = blueBlobs(i).vc;
        elseif (locationColumn > 1.4)
            % right column
            Pb(1, 3) = blueBlobs(i).uc;
            Pb(2, 3) = blueBlobs(i).vc;
        else
            % middle column
            Pb(1, 2) = blueBlobs(i).uc;
            Pb(2, 2) = blueBlobs(i).vc;
        end
    elseif (locationRow > 1.4)
        % build row 3
        if (locationColumn < 0.6)
            % left column
            Pb(1, 7) = blueBlobs(i).uc;
            Pb(2, 7) = blueBlobs(i).vc;
            originCoOrd = [blueBlobs(i).umin; blueBlobs(i).vmax];
            origBlob = blueBlobs(i);
        elseif (locationColumn > 1.4)
            % right column
            Pb(1, 9) = blueBlobs(i).uc;
            Pb(2, 9) = blueBlobs(i).vc;
        else
            % middle column
            Pb(1, 8) = blueBlobs(i).uc;
            Pb(2, 8) = blueBlobs(i).vc;
        end
    else
        % build row 2
        if (locationColumn < 0.6)
            % left column
            Pb(1, 4) = blueBlobs(i).uc;
            Pb(2, 4) = blueBlobs(i).vc;
        elseif (locationColumn > 1.4)
            % right column
            Pb(1, 6) = blueBlobs(i).uc;
            Pb(2, 6) = blueBlobs(i).vc;
        else
            % middle column
            Pb(1, 5) = blueBlobs(i).uc;
            Pb(2, 5) = blueBlobs(i).vc;
        end
    end
end

    %% Question 5
    %---Homeography---
    %Get coordinates of blue circle centroids.
    
    %Q Matrix of centroid points.
    %Plots detected blue circles in a 580 x 580 grid.

    % Matrix of points    

    H = homography(Pb, Q');
    [homImg, imageOffSets] = homwarp(H, inputImg, 'full', 'extrapval', 0.9);
    imageOffSets = -imageOffSets';

    idisp(homImg);
    hold on;
    
    homOriginCoOrd = homtrans(H, originCoOrd) + imageOffSets;
    
    q = [];
    for i=1:length(targetBlobs)
        p = [targetBlobs(i).uc targetBlobs(i).vc];
        q = [q; (homtrans(H, p') + imageOffSets)'];
    end
    
    uMMArr = {};
    vMMArr = {};
    for i=1:length(q)
        uMM = q(i, 1);
        vMM = q(i, 2);
        if i == 1
            plot(uMM, vMM, '*g');
        end
        if i == 4
            plot(uMM, vMM, 'og');
        end
        if i == 2
            plot(uMM, vMM, '*r');
        end
        if i == 5
            plot(uMM, vMM, 'or');
        end
        if i == 3
            plot(uMM, vMM, '*b');
        end
        if i == 6
            plot(uMM, vMM, 'ob');
        end
        
        uMM = uMM - homOriginCoOrd(1);
        vMM = homOriginCoOrd(2) - vMM;
        
        uMMArr = [uMMArr uMM];
		vMMArr = [vMMArr vMM];
        
        fprintf('TargetBlob %d is at (%.2fmm, %.2fmm)\n', i, vMM, 560-uMM+19);
    end
    
    uMMArr = cell2mat(uMMArr);
    vMMArr = cell2mat(vMMArr);
    
    %% Moving
	
    %claw.setAllJointsPosition([0 (89*2.875) 180 180 123]);
    pause(2);
	for i=1:3
		%moveArm(claw, vMMArr(i), uMMArr(i), vMMArr(i+3), uMMArr(i+3));
	end
    
    % %% %% %% %%
    % This section is just for a sanity check - to visually see if it is
    % all working.
    
    % Display origin for all measurments to ensure it is all working.
    plot(homOriginCoOrd(1), homOriginCoOrd(2), 'Xg');
    
    % Display 9 blue centroids for confirmation that this is working
    % and aligned etc.
    homPb = (homtrans(H, Pb)+imageOffSets)';
    for i=1:length(homPb)
       plot(homPb(i,1), homPb(i,2), 'oc');
    end
    
    % %% %% %% %%

    
end 