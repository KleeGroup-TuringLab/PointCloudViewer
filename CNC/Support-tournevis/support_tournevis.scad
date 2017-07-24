difference() {
    union() {
        translate([-120, 0, 0])
            cube([240, 56, 60]);
        for (a =[0:6])
        translate([a * 38.125 - (120 - (240 - 8 - 6*38.125) / 2), -8, 52])
            cube([8,8,8]);

        for (a =[0:6])
        translate([a * 38.125 - (120 - (240 - 8 - 6*38.125) / 2), -8, 52 - 38.125])
            cube([8,8,8]);
    }
    union() {
        translate([-121, 4, -1])
            cube([242, 56, 18]);
        translate([-121, 32, 41])
            cube([242, 56, 20]);

        translate([-121, -2, 51])
            cube([242, 2, 5]);
        translate([-121, -2, 51 - 38.125])
            cube([242, 2, 5]);
        
        translate([-104, 45, 0])
            cylinder(d=12, h=60);
        translate([104, 45, 0])
            cylinder(d=12, h=60);

        translate([-104, 15, 0])
            cylinder(d=12, h=60);
        translate([104, 15, 0])
            cylinder(d=12, h=60);

        translate([-65, 15, 0])
            cylinder(d=12, h=60);
        translate([65, 15, 0])
            cylinder(d=12, h=60);

        translate([-23, 18, 0])
            cylinder(d=12, h=60);
        translate([23, 18, 0])
            cylinder(d=12, h=60);

        translate([-76, 45, 0])
            cylinder(d=5, h=60);
        translate([76, 45, 0])
            cylinder(d=5, h=60);

        translate([-59, 45, 0])
            cylinder(d=5, h=60);
        translate([59, 45, 0])
            cylinder(d=5, h=60);

        translate([-42, 45, 0])
            cylinder(d=5, h=60);
        translate([42, 45, 0])
            cylinder(d=5, h=60);

        translate([-25, 45, 0])
            cylinder(d=5, h=60);
        translate([25, 45, 0])
            cylinder(d=5, h=60);

        translate([-8, 45, 0])
            cylinder(d=5, h=60);
        translate([8, 45, 0])
            cylinder(d=5, h=60);
    }
}
