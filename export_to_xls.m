function export_to_xls(results , fileName)  

fid = fopen(fileName,'a+');

fprintf(fid,'Exam on : %s\n', date);

fprintf(fid,'File ; %s\n',results.File);

fprintf(fid,'studyCode ; %s\n',results.studyCode);
fprintf(fid,'subjectCode ; %s\n',results.subjectCode);
fprintf(fid,'comments ; %s\n',results.comments);

fprintf(fid,'Ratio of noisy cycles ; %.2f\n',1-results.tolThres);
fprintf(fid,'Final cycle number ; %d\n',results.cycleNumber);

fprintf(fid,'age (y); %.1f\n',results.age);
fprintf(fid,'size (cm) ; %.1f\n',results.height);
fprintf(fid,'sex ; %d\n',results.sex);

fprintf(fid,'CVI ; %.1f\n',results.cvi);

fprintf(fid,'SwingPga(cmH20) ; %.1f\n',results.SwingPga);
fprintf(fid,'SwingPes(cmH20) ; %.1f\n',results.SwingPes);
fprintf(fid,'SwingPdi(cmH20) ; %.1f\n',results.SwingPdi);
fprintf(fid,'CLdyn(L/cmH20) ; %.3f\n',results.CLdyn);
fprintf(fid,'Res (cmH20/L/s); %.1f\n',results.Res);
fprintf(fid,'AutoPEEP(L/cmH20) ; %.1f\n',results.AutoPEEP);

         
fprintf(fid,'Ti(s) ; %.1f\n',results.Ti);
fprintf(fid,'Texp(s) ; %.1f\n',results.Texp);
fprintf(fid,'Ttot(s) ; %.1f\n',results.Ttot);
fprintf(fid,'Ti_Ttot(s) ; %.1f\n',results.Ti_Ttot);
fprintf(fid,'freq  (cycles/min) ; %.1f\n',results.freq);


fprintf(fid,'PTPes  (cmH20*s) ; %.2f\n',results.PTPes);
fprintf(fid,'PTPdi (cmH20*s) ; %.2f\n',results.PTPdi);
fprintf(fid,'PTPesC (cmH20/cycle) ; %.2f\n',results.PTPesC);
fprintf(fid,'PTPdiC (cmH20/cycle) ; %.2f\n',results.PTPdiC);


fprintf(fid,'Vt (L) ; %.3f\n',results.Vt);
fprintf(fid,'Vt_Ti (L) ; %.2f\n',results.Vt_Ti);
fprintf(fid,'FR_VT (L); %.2f\n',results.FR_VT);


fprintf(fid,'Wel (J/cycle) ; %.3f\n',results.Wel);
fprintf(fid,'Wres_insp (J/cycle); %.3f\n',results.Wres_insp);
fprintf(fid,'Wres_exp (J/cycle); %.3f\n',results.Wres_exp);
fprintf(fid,'Wres (J/cycle) ; %.3f\n',results.Wres);
fprintf(fid,'W (J/cycle); %.3f\n',results.W);
fprintf(fid,'Wexp (J/cycle) ; %.3f\n',results.Wexp);

fclose(fid);