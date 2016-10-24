difference() {
	translate([-15, -5, 0])
		cube([125, 90, 3]);
	union() {
        for (j=[0:4])
        for (i=[0:5])
            translate([i*15 + 10, j*15 + 10, 0])
                cylinder(d=10, h=12.4, $fn=100);
        
		translate([-2.5, -2.5, 0])
			cylinder(d=3, h=12.4, $fn=100);
		translate([105 -5 -2.5, -2.5, 0])
			cylinder(d=3, h=12.4, $fn=100);
		translate([-2.5, 90 -5 -2.5, 0])
			cylinder(d=3, h=12.4, $fn=100);
		translate([105 -5 -2.5, 90 -5 -2.5, 0])
			cylinder(d=3, h=12.4, $fn=100);
	}
}
