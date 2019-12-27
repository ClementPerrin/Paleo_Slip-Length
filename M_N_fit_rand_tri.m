function [Lint,Dint,Ll_M,Lr_M,Ls_M,Ds_M,aicc_M,wrms_M] = M_N_fit_rand_tri(Nl,Nr,L,D,W,Nt,Lln,Llx,Lsn,Lsx,Dsn,Dsx,Lrn,Lrx)

% [Lint,Dint,Ll_M,Lr_M,Ls_M,Ds_M,aicc_M,wrms_M] = M_N_fit_rand_tri(Nl,Nr,L,D,W,Nt,Lln,Llx,Lsn,Lsx,Dsn,Dsx,Lrn,Lrx)
% achieves Nl loops of N_fit_rand_tri.
%
% Inputs
%
% Nl          : nb of loops, each loop containing N-runs
% Nr          : nb of runs with random choices of triangles
% L           : horizontal distances along fault
% D           : Offset values
% W           : weights of D values
% Nt          : nb of triangles
% Lln         : minimum abscissa of triangle left end
% Llx         : maximum abscissa of triangle left end
% Lsn         : minimum abscissa of triangle summit
% Lsx         : maximum abscissa of triangle summit
% Dsn         : minimum incremental offset at triangle summit
% Dsx         : maximum incremental offset at triangle summit
% Lrn         : minimum abscissa of triangle right end
% Lrx         : maximum abscissa of triangle right end
%
% Outputs
%
% Lint        : array of Nt x 100 horizontal distances along the fault
% Dint        : array of Nt x 100 theoretical offsets along the fault
% Ll_M        : Nt x Nl array to store abscissae at left ends of triangles
% Lr_M        : Nt x Nl array to store abscissae at right ends of triangles
% Ls_M        : Nt x Nl array to store abscissae of triangle summits
% Ds_M        : Nt x Nl array to store offset values at triangle summits
% aicc_M      : 1 x Nl vector to store AICC for each loop
% wrms_M      : 1 x Nl vector to store weighted rms values for each loop
%
% Yves Gaudemer - IPGP - 2019/12/27

% Initial tests

if exist('geom2d','dir') == 0 || exist('geom3d','dir') == 0 || exist('polygons2d','dir') == 0
    error('The geom2d, geom3d, and polygons2d (part of matGeom) folders\n%s',...
        'must be on your Matlab path for this set of programs to work')
end

Ll_M = zeros(Nt,Nl) ;
Lr_M = zeros(Nt,Nl) ;
Ls_M = zeros(Nt,Nl) ;
Ds_M = zeros(Nt,Nl) ;
aicc_M = zeros(1,Nl) ;
wrms_M = zeros(1,Nl) ;
Tint = zeros(Nt,100) ;
Dint = zeros(Nt,100) ;

color_order = [1 0 0 ; 0 1 0 ; 0 0 1 ; 0 1 1 ; 1 0 1 ; 1 0.65 0] ; % rgbcmo
color_order = [color_order ; 1 0 0 ; 0 1 0 ; 0 0 1 ; 0 1 1 ; 1 0 1 ; 1 0.65 0] ; % To plot more than 6 triangles
linewidth_order = [ 2 ; 2 ; 2 ; 2 ; 2 ; 2 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1] ;


for k = 1:Nl
    
    [Ll,Lr,Ls,Ds,aicc,wrms] = N_fit_rand_tri(Nr,L,D,W,Nt,Lln,Llx,Lsn,Lsx,Dsn,Dsx,Lrn,Lrx) ;
    Ll_M(:,k) = Ll ;
    Lr_M(:,k) = Lr ;
    Ls_M(:,k) = Ls ;
    Ds_M(:,k) = Ds ;
    aicc_M(k) = aicc ;
    wrms_M(k) = wrms ;
    
end

% Computing the average triangles

Ll_m = mean(Ll_M,2) ;
Ls_m = mean(Ls_M,2) ;
Ds_m = mean(Ds_M,2) ;
Lr_m = mean(Lr_M,2) ;

% Computing successive offsets

for i = 1:Nt

    Lc = [Ll_m(i) Ls_m(i) Lr_m(i)] ;
    Dc = [0 Ds_m(i) 0] ;
    Lint = linspace(Ll_m(i),Lr_m(i),100) ;
    Tint(i,:) = interp1(Lc,Dc,Lint) ;
    
end

% Computing individual offsets from cumulative offsets

Dint(1,:) = Tint(1,:) ;

for i = 2:Nt
    
    Dint(i,:) = Tint(i,:) - Tint(i-1,:) ;
    
end

text_line_1 = [sprintf('%0.0f',Lln),' km < L_l < ',sprintf('%0.0f',Llx),' km'] ;
text_line_2 = [sprintf('%0.0f',Lsn),' km < L_s < ',sprintf('%0.0f',Lsx),' km'] ;
text_line_3 = [sprintf('%0.0f',Dsn),' km < D_s < ',sprintf('%0.0f',Dsx),' km'] ;
text_line_4 = [sprintf('%0.0f',Lrn),' km < L_r < ',sprintf('%0.0f',Lrx),' km'] ;
text_lines = {text_line_1 ; text_line_2 ; text_line_3 ; text_line_4} ;

% Figure 1 : Plot of the Nl best triangles

title_line = ['Nl = ',int2str(Nl),' best sets of Nt = ',...
    int2str(Nt),' triangles, each obtained from Nr = ',int2str(Nr),' runs'] ;

figure ; hold on

legend_text = cell(Nt,1) ;
hplot = [] ;

for i = 1:Nt

    triangle = [Ll_M(i,1) 0 ; Ls_M(i,1) Ds_M(i,1) ; Lr_M(i,1) 0] ;
    hp = drawPolyline(triangle,'Color',color_order(i,:)) ;
    hplot = [hplot hp] ;
    legend_text{i} = ['Earthquake ',int2str(i)] ;

end

% Keeps the legend and removes the previous plot
legend(legend_text,'AutoUpdate','off') ; delete(hplot)
    
for k = 1:Nl
    
    for i = 1:Nt
        
        triangle = [Ll_M(i,k) 0 ; Ls_M(i,k) Ds_M(i,k) ; Lr_M(i,k) 0] ;
        drawPolyline(triangle,'Color',color_order(i,:)) ;
        
    end
       
end

% Overlay with the average triangles

for i = 1:Nt

    triangle = [Ll_m(i) 0 ; Ls_m(i) Ds_m(i) ; Lr_m(i) 0] ;
    drawPolyline(triangle,'k-','LineWidth',2) ;
    text(Ls_m(i),Ds_m(i),int2str(i),'VerticalAlignment','bottom') ;

end

ax = gca ;
xtext = ax.XLim(1) + 0.05*(ax.XLim(2) - ax.XLim(1)) ;
ytext = ax.YLim(2) - 0.05*(ax.YLim(2) - ax.YLim(1)) ;
text(xtext,ytext,text_lines,'VerticalAlignment','top','FontSize',9)

xlabel('Horizontal distance (km)')
ylabel('Offset value (m)')
title(title_line)
box on, hold off

% Figure 2 : Plot the average triangles and data points

title_line = ['Nt = ',int2str(Nt),' triangles averaged from ',int2str(Nl),' loops of ',int2str(Nr),' runs'] ;

legend_text = cell(Nt,1) ;

figure, hold on

for i = 1:Nt
    
    triangle = [Ll_m(i) 0 ; Ls_m(i) Ds_m(i) ; Lr_m(i) 0] ;
    drawPolyline(triangle,'Color',color_order(i,:),'LineWidth',linewidth_order(i)) ;
    text(Ll_m(i),0,[sprintf('%0.1f',Ll_m(i)),'   '],...
        'HorizontalAlignment','right',...
        'VerticalAlignment','bottom',...
        'Color',color_order(i,:))
    text(Lr_m(i),0,['   ',sprintf('%0.1f',Lr_m(i))],...
        'HorizontalAlignment','left',...
        'VerticalAlignment','bottom',...
        'Color',color_order(i,:))
    text(Ls_m(i),Ds_m(i),['(',sprintf('%0.1f',Ls_m(i)),',',sprintf('%0.1f',Ds_m(i)),')'],...
        'HorizontalAlignment','center',...
        'VerticalAlignment','bottom',...
        'Color',color_order(i,:))
    
    legend_text{i} = ['Earthquake ',int2str(i)] ;
    
end
legend(legend_text,'AutoUpdate','off')

for j = 1:numel(L)
    
    dist = zeros(Nt,1) ;
    point = [L(j) D(j)] ;
    
    for i = 1:Nt
        
        triangle = [Ll_m(i) 0 ; Ls_m(i) Ds_m(i) ; Lr_m(i) 0] ;
        dist(i) = abs(dist2triangle(point,triangle)) ;
        
    end
    
    imin = find(dist == min(dist)) ;
        
    plot(L(j),D(j),'o',...
        'MarkerFaceColor',color_order(imin,:),...
        'MarkerEdgeColor',color_order(imin,:))
    
end

xlabel('Horizontal distance (km)')
ylabel('Offset value (m)')
title(title_line)

ax = gca ;
xtext = ax.XLim(1) + 0.05*(ax.XLim(2) - ax.XLim(1)) ;
ytext = ax.YLim(2) - 0.05*(ax.YLim(2) - ax.YLim(1)) ;
text(xtext,ytext,text_lines,'VerticalAlignment','top','FontSize',9)

box on, hold off

hold off

% Figure 3 : plot of the average slip distribution for each earthquake

title_line = ['Average slip distribution for each of the ',int2str(Nt),' earthquakes'] ;

figure, hold on

legend_text = cell(Nt,1) ;

for i = 1:Nt
    
    plot(Lint,Dint(i,:),...
        'Color',color_order(i,:),...
        'LineWidth',linewidth_order(i))
    legend_text{i} = ['Earthquake ',int2str(i)] ;
    
end

xlabel('Horizontal distance (km)')
ylabel('Offset value (m)')
title(title_line)
ax = gca ;
xtext = ax.XLim(1) + 0.05*(ax.XLim(2) - ax.XLim(1)) ;
ytext = ax.YLim(2) - 0.05*(ax.YLim(2) - ax.YLim(1)) ;
text(xtext,ytext,text_lines,'VerticalAlignment','top','FontSize',9)

box on, hold off

legend(legend_text)
