

/*
 * Include Files
 *
 */
#if defined(MATLAB_MEX_FILE)
#include "tmwtypes.h"
#include "simstruc_types.h"
#else
#include "rtwtypes.h"
#endif

/* %%%-SFUNWIZ_wrapper_includes_Changes_BEGIN --- EDIT HERE TO _END */
#include <math.h>
static double x_i = 0;
static double y_i = 0;
static double x_pozisyon = 0;
static double y_pozisyon = 0;
static int zadim = 500;
static double x_adim = 0;
static double y_adim = 0;
static double z_adim = zadim;
static bool bekle = false;
static double index = 0;
static bool x_geldik = false;
static bool y_geldik = false;
static bool x_dalga = false;
static bool y_dalga = false;
static double x_stepsayisi = 0;
static double y_stepsayisi = 0;
static double x_pulsetutucu = 0;
static double y_pulsetutucu = 0;
static double x_pulsesayaci = 0;
static double y_pulsesayaci = 0;
static bool x_pulsetutuluyor = true;
static bool y_pulsetutuluyor = true;
static bool init = true;
static bool xgeldi = false;
static bool ygeldi = false;
static int xdepo = 0;
static int ydepo = 0;
static int xyon = 1;
static int yyon = 1;

/* %%%-SFUNWIZ_wrapper_includes_Changes_END --- EDIT HERE TO _BEGIN */
#define u_width 1
#define y_width 1
/*
 * Create external references here.  
 *
 */
/* %%%-SFUNWIZ_wrapper_externs_Changes_BEGIN --- EDIT HERE TO _END */
/* extern double func(double a); */
/* %%%-SFUNWIZ_wrapper_externs_Changes_END --- EDIT HERE TO _BEGIN */
double min(double x,double y){
    if(x > y){
        return y;
    } else {
        return x;
    }
}
/*
 * Output functions
 *
 */
extern "C" void StepMotor_Outputs_wrapper(const real_T *x_target,
			const real_T *y_target,
			const real_T *x_pulse,
			const real_T *y_pulse,
			const real_T *z_pulse,
			const real_T *x_limit,
			const real_T *y_limit,
			const real_T *z_input,
			real_T *x_step,
			real_T *y_step,
			real_T *z_step,
			real_T *x_dir,
			real_T *y_dir,
			real_T *z_dir,
			real_T *enable,
			real_T *index)
{ 
                //Initialization     
if (init == true){
    if (xgeldi == false || ygeldi == false){ //ölümüne
        *enable=0;
        if (*x_limit <= 1022){
            xgeldi = false;
            *x_dir = 0;
            *x_step = *x_pulse;
        } else {
            xgeldi = true;
        }
        if (*y_limit <= 1022){
            ygeldi = false;
            *y_dir = 0;
            *y_step = *y_pulse;
        } else {
            ygeldi = true;
        }
    } else { //ortala
        if (x_i < 250){
            *x_dir = 5;
            *x_step = *x_pulse;//bu sürüyo
            if (*x_pulse == 0){ 
                x_dalga = false;
            }
            if (*x_pulse > 0 && x_dalga == false){
                x_dalga = true;
                x_i++;  
            }
            if (x_i >= 250){ 
                x_pozisyon = 175;
            }
        } 
        if (y_i < 465){
            *y_dir = 5;
            *y_step = *y_pulse;//bu sürüyo
            if (*y_pulse == 0){ 
                y_dalga = false;
            }
            if (*y_pulse > 0 && y_dalga == false){
                y_dalga = true;
                y_i++;  
            }
            if (y_i >= 465){ 
                y_pozisyon = 375;
            }
        } 
    }
    if (x_pozisyon >= 175 && y_pozisyon >= 375){ //sýfýrla
        init = false;
        *enable = 5;
        x_i = 0;
        y_i = 0;
    }
} else {        //Çizim
          //depo
    if (xdepo != *x_target){
        x_pozisyon = x_pozisyon + x_i * xyon;
        x_i = 0;
    } 
    if (ydepo != *y_target){
        y_pozisyon = y_pozisyon + y_i * yyon;
        y_i = 0;
    }
    xdepo = *x_target;
    ydepo = *y_target;
    
        //index
    if (*x_target != x_pozisyon && *y_target != y_pozisyon ){
        bekle = false;
    } else if (bekle == false){
        index++;
        bekle = true;
    }

        //enable
    if ((*x_target == x_pozisyon && *y_target == y_pozisyon) && ((*z_input != 0 || z_adim >= zadim) && (*z_input == 0 || z_adim <= 0))){
        *enable = 5;
    } else {
        *enable = 0;
    }

        //yön X
    if (*x_target > x_pozisyon){
        *x_dir = 5;
        x_adim = *x_target - x_pozisyon;
        xyon = 1;
    } else if (x_pozisyon > *x_target){
        *x_dir = 0;
        x_adim = x_pozisyon - *x_target;
        xyon = -1;
    } 
        //yön Y
    if (*y_target > y_pozisyon){
        *y_dir = 5;
        y_adim = *y_target - y_pozisyon;
        yyon = 1;
    } else if (y_pozisyon > *y_target){
        *y_dir = 0;
        y_adim = y_pozisyon - *y_target;
        yyon = -1;
    }
        //yön Z
    if (*z_input == 0){
        *z_dir = 5;
    } else {
        *z_dir = 0;
    }

        //Hýz Ayarlarý
    if (x_adim > y_adim){
        x_pulsetutucu = 0;
        y_pulsetutucu = min((round(x_adim/y_adim)-1),40);
    } else if (y_adim > x_adim){
        y_pulsetutucu = 0;
        x_pulsetutucu = min((round(y_adim/x_adim)-1),40);
    }

        //x sürüþ
    if (*x_target == x_pozisyon){
        x_i = 0;
    } else {
        if (x_pulsesayaci >= x_pulsetutucu){
            *x_step = *x_pulse;//bu sürüyo 
            x_pulsetutuluyor = false;
        }
        if (*x_pulse == 0){ 
            x_dalga = false;
        }
        if (*x_pulse > 0 && x_dalga==false && x_pulsetutuluyor == true){
            x_pulsesayaci++; 
            x_dalga = true;
        }   
        if (*x_pulse > 0 && x_dalga == false && x_pulsetutuluyor == false){
            x_dalga = true;
            x_i++;  
            x_pulsetutuluyor = true;
            x_pulsesayaci = 0;
        }
        if (x_i >= x_adim){ 
            x_pozisyon = *x_target;
        }
    }    
        //y sürüþ
    if (*y_target == y_pozisyon){
        y_i = 0;
    } else {
        if (y_pulsesayaci >= y_pulsetutucu){
            y_pulsetutuluyor = false;
            *y_step = *y_pulse;//bu sürüyo
        }
        if (*y_pulse == 0){ 
            y_dalga = false;
        }
        if (*y_pulse > 0 && y_dalga == false && y_pulsetutuluyor == true){
            y_pulsesayaci++;
            y_dalga = true;
        }
        if (*y_pulse > 0 && y_dalga == false && y_pulsetutuluyor == false){
            y_dalga = true;
            y_i++;
            y_pulsetutuluyor = true;
            y_pulsesayaci = 0;
        }
        if (y_i >= y_adim){ 
            y_pozisyon = *y_target;
        }
    }
        //z sürüþ    //liseli esad lise lise lise liseli esoþ
    if (*z_input == 0){
        if (z_adim < zadim){
            z_adim++;
            *z_step = *z_pulse;//bu sürüyo
        } 
    } else {
        if(z_adim > 0){
            z_adim--;
            *z_step = *z_pulse;//bu sürüyo
        }
    }
}
}
