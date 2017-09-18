$fn = 50;
r=14.1;
r1=1.7;

// Diamètre extérieur tube : 26.2
// Diamètre interne tube : 24
// Pas : 7


difference() {
    union() {
        // Base
        translate([-39 / 2, -39 / 2, 0 ])
            minkowski() {
                cube([39, 39, 4]);
                cylinder(r=5, h=1);
            }
            
        // Cylindre interne
        cylinder(d=39, h=20);
            
        // Coude
        translate([-18, 0, 0])
            intersection() {
                rotate([90, 0, 0])
                    rotate_extrude(convexity = 10)
                        translate([18, 0, 0])
                            circle(d = 30);
                translate([0, -20, -40])
                    cube([40, 40, 40]);
            }
            
        // Tube extérieur
        translate([-28, 0, -18])
            rotate([0, 90, 0])
                cylinder(d=40, h=10);
        // Tube extérieur
        translate([-44.5, 0, -18])
            rotate([0, 90, 0])
                cylinder(d=40, h=20);
            
        // Renfort
        translate([-24.5, -5, -20])
            cube([20, 10, 20]);
    }
    union() {
        // Vis de fixation
        for (i=[0:3]) {
            rotate([0, 0, i * 90])
                translate([-39 / 2, -39 / 2, 0 ])
                    union() {
                        cylinder(d=4.4, h=5);
                        cylinder(d1=7, d2=4.4, h=2);
                        translate([0,0,-50])
                            cylinder(d=7, h=50);
                    }
        }
        
        // Passage intérieur
        cylinder(d=24, h=20);
        
        // Passage Coude
        translate([-18, 0, 0])
            intersection() {
                rotate([90, 0, 0])
                    rotate_extrude(convexity = 10)
                        translate([18, 0, 0])
                            circle(d = 24);
                translate([0, -20, -40])
                    cube([40, 40, 40]);
            }
        
        // Passage extérieur
        translate([-44.5, 0, -18])
            rotate([0, 90, 0])
                cylinder(d=24, h=30);
            
        // Filetage bas
        linear_extrude(height = 7 * 3, center = false, convexity = 10, twist = -360 * 3, $fn = 100)
            polygon([
                [(r - r1 + r1 * sin(  0)) * cos(  0), (r - r1 + r1 * sin(  0)) * sin(  0)],
                [(r - r1 + r1 * sin( 10)) * cos( 10), (r - r1 + r1 * sin( 10)) * sin( 10)],
                [(r - r1 + r1 * sin( 20)) * cos( 20), (r - r1 + r1 * sin( 20)) * sin( 20)],
                [(r - r1 + r1 * sin( 30)) * cos( 30), (r - r1 + r1 * sin( 30)) * sin( 30)],
                [(r - r1 + r1 * sin( 40)) * cos( 40), (r - r1 + r1 * sin( 40)) * sin( 40)],
                [(r - r1 + r1 * sin( 50)) * cos( 50), (r - r1 + r1 * sin( 50)) * sin( 50)],
                [(r - r1 + r1 * sin( 60)) * cos( 60), (r - r1 + r1 * sin( 60)) * sin( 60)],
                [(r - r1 + r1 * sin( 70)) * cos( 70), (r - r1 + r1 * sin( 70)) * sin( 70)],
                [(r - r1 + r1 * sin( 80)) * cos( 80), (r - r1 + r1 * sin( 80)) * sin( 80)],
                [(r - r1 + r1 * sin( 90)) * cos( 90), (r - r1 + r1 * sin( 90)) * sin( 90)],
                [(r - r1 + r1 * sin(100)) * cos(100), (r - r1 + r1 * sin(100)) * sin(100)],
                [(r - r1 + r1 * sin(110)) * cos(110), (r - r1 + r1 * sin(110)) * sin(110)],
                [(r - r1 + r1 * sin(120)) * cos(120), (r - r1 + r1 * sin(120)) * sin(120)],
                [(r - r1 + r1 * sin(130)) * cos(130), (r - r1 + r1 * sin(130)) * sin(130)],
                [(r - r1 + r1 * sin(140)) * cos(140), (r - r1 + r1 * sin(140)) * sin(140)],
                [(r - r1 + r1 * sin(150)) * cos(150), (r - r1 + r1 * sin(150)) * sin(150)],
                [(r - r1 + r1 * sin(160)) * cos(160), (r - r1 + r1 * sin(160)) * sin(160)],
                [(r - r1 + r1 * sin(170)) * cos(170), (r - r1 + r1 * sin(170)) * sin(170)],
                [(r - r1 + r1 * sin(180)) * cos(180), (r - r1 + r1 * sin(180)) * sin(180)]
            ]);                                               

        // Filetage haut
        translate([-44.5, 0, -18])
            rotate([0, 90, 0])
                linear_extrude(height = 7 * 3, center = false, convexity = 10, twist = -360 * 3, $fn = 100)
            polygon([
                [(r - r1 + r1 * sin(  0)) * cos(  0), (r - r1 + r1 * sin(  0)) * sin(  0)],
                [(r - r1 + r1 * sin( 10)) * cos( 10), (r - r1 + r1 * sin( 10)) * sin( 10)],
                [(r - r1 + r1 * sin( 20)) * cos( 20), (r - r1 + r1 * sin( 20)) * sin( 20)],
                [(r - r1 + r1 * sin( 30)) * cos( 30), (r - r1 + r1 * sin( 30)) * sin( 30)],
                [(r - r1 + r1 * sin( 40)) * cos( 40), (r - r1 + r1 * sin( 40)) * sin( 40)],
                [(r - r1 + r1 * sin( 50)) * cos( 50), (r - r1 + r1 * sin( 50)) * sin( 50)],
                [(r - r1 + r1 * sin( 60)) * cos( 60), (r - r1 + r1 * sin( 60)) * sin( 60)],
                [(r - r1 + r1 * sin( 70)) * cos( 70), (r - r1 + r1 * sin( 70)) * sin( 70)],
                [(r - r1 + r1 * sin( 80)) * cos( 80), (r - r1 + r1 * sin( 80)) * sin( 80)],
                [(r - r1 + r1 * sin( 90)) * cos( 90), (r - r1 + r1 * sin( 90)) * sin( 90)],
                [(r - r1 + r1 * sin(100)) * cos(100), (r - r1 + r1 * sin(100)) * sin(100)],
                [(r - r1 + r1 * sin(110)) * cos(110), (r - r1 + r1 * sin(110)) * sin(110)],
                [(r - r1 + r1 * sin(120)) * cos(120), (r - r1 + r1 * sin(120)) * sin(120)],
                [(r - r1 + r1 * sin(130)) * cos(130), (r - r1 + r1 * sin(130)) * sin(130)],
                [(r - r1 + r1 * sin(140)) * cos(140), (r - r1 + r1 * sin(140)) * sin(140)],
                [(r - r1 + r1 * sin(150)) * cos(150), (r - r1 + r1 * sin(150)) * sin(150)],
                [(r - r1 + r1 * sin(160)) * cos(160), (r - r1 + r1 * sin(160)) * sin(160)],
                [(r - r1 + r1 * sin(170)) * cos(170), (r - r1 + r1 * sin(170)) * sin(170)],
                [(r - r1 + r1 * sin(180)) * cos(180), (r - r1 + r1 * sin(180)) * sin(180)]
            ]);
    }
}
