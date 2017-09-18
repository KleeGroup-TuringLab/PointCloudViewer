$fa=0.1;
$fn=32;

SOCLE =1.4;

module SdCard() {
    difference() {
        union() {
            difference() {
                union() {
                    // Plein gauche/droite
                    cube([22, 32, SOCLE]);
                    cube([22, 32, 2]);
                    // Plein avant/arriere
                    translate ([-1, 1, 0]) cube([24, 30, SOCLE]);
                    translate ([-0.5, 0.5, 0]) cube([23, 31, 2]);
                    // Coin bas gauche
                    translate([0, 1, 0])cylinder(h=SOCLE, r=1);
                    translate([0, 0.5, 0])cylinder(h=2, r=0.5);
                    // Coin bas droit
                    translate([22, 1, 0]) cylinder(h=SOCLE, r=1);
                    translate([22, 0.5, 0])cylinder(h=2, r=0.5);
                    // Coin haut droit
                    translate([22, 31, 0]) cylinder(h=SOCLE, r=1);
                    translate([22, 31.5, 0])cylinder(h=2, r=0.5);
                }
                // Pins 1 à 8
                // translate ([-5, 26.05, 1.4]) cube([50, 8, 1], center=false);
                // Pins 9
                // translate ([-6, 24.05, 1.4]) cube([9, 8, 1], center=false);
                
                translate ([ 0.25, 30, 2]) cube([5, 10, 0.7], center=true);
                translate ([ 4.25, 30, 2]) cube([2, 8, 0.7], center=true);
                translate ([ 6.75, 30, 2]) cube([2, 8, 0.7], center=true);
                translate ([ 9.25, 30, 2]) cube([2, 8, 0.7], center=true);
                translate ([11.75, 30, 2]) cube([2, 8, 0.7], center=true);
                translate ([14.25, 30, 2]) cube([2, 8, 0.7], center=true);
                translate ([16.75, 30, 2]) cube([2, 8, 0.7], center=true);
                translate ([21   , 30, 2]) cube([5.5, 8, 0.7], center=true);
                
                // Cut
                translate ([-5, 20.5, -1]) cube([4.5, 1.5, 4], center=false);
                // Lock cut
                translate ([22.5, 17.5, -1]) cube([5, 6.7, 4], center=false);
                // inner space
                translate ([0, -0.5, 0.35]) cube([22, 32, 1.3], center=false);
                
            }
            // Not locked
            translate ([22, 20.85, 0]) cube([1, 3.35, 1.4], center=false);
            // Pin separators
/*
            translate ([ 3  , 28, 1]) cube([0.5, 8, 2], center=true);
            translate ([ 5.5, 28, 1]) cube([0.5, 8, 2], center=true);
            translate ([ 8  , 28, 1]) cube([0.5, 8, 2], center=true);
            translate ([10.5, 28, 1]) cube([0.5, 8, 2], center=true);
            translate ([13  , 28, 1]) cube([0.5, 8, 2], center=true);
            translate ([15.5, 28, 1]) cube([0.5, 8, 2], center=true);
            translate ([18  , 28, 1]) cube([0.5, 8, 2], center=true);
*/
        }
        // Angle coupé
        translate ([-1, 28, -1]) rotate(a=[0, 0, 45]) cube([8, 4, 4], center=false);
    }
}


difference() {
    SdCard();
    translate ([0, 0, 2]) cube([100, 100, 1.2], center=true);
}

difference() {
    translate ([0, -5, 2]) rotate(a=[180, 0, 0])
        SdCard();
    translate ([0, 0, 2]) cube([100, 100, 2.8], center=true);
}
