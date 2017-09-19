$fn=128;
$fa=0.05;

output = 2;

module plug(diam, wall, ajust) {
    difference(){
        union() {
        cylinder(h=diam,d=diam*0.8);
        translate([0,0,diam*0.9])
            cylinder(h=diam,d1=diam+ajust,d2=diam*0.7);
        translate([0,0,2*diam*0.9])
            cylinder(h=diam,d1=diam,d2=diam*0.65);
        translate([0,0,3*diam*0.9])
            cylinder(h=diam,d1=diam-ajust,d2=diam*.6);
        }
        translate([0,0,-1])
        cylinder(h=5*diam,d=diam*0.7-2*wall);
    }
}

union() {
     translate([0, 0, -2]) plug(8, 0.8, 0.3);
     rotate([180, 0, 0])
     translate([0, 0, -2]) plug(9.5, 0.8, 0.3);
}