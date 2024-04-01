function Get_LPC_Coef_TestDriver()
    addpath("./lib/")
    x = getLpcCoef([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], 4, false);
    disp(x);

    y = getLpcCoef([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], 4, true);
    disp(y);
end