load ROF_CODAR_20160502_4350_ch0.mat 
imagesc(t,range(rangeix),rngmap); 
set(gca,'YDir','norm');  
set(gca,'FontName','Gill Sans','FontSize',16);  xlabel('Universal Time [hrs]');  ylabel('Group Range [km, wrt arb ref]');  title('ROF CODAR 4350 kHz 20160502 ch 0');  h = colorbar;  ylabel(h,'Power [dB wrt arb ref]');  set(h,'FontName','Gill Sans','FontSize',16);
set(gca,'CLim',[-140 -70]);