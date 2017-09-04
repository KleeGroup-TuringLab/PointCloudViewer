D = 12.65;
D1 = 14.5;
d = 3.3;
L = 26;
L1 = 4;
L2 = 1;
L3 = 4.5;

D2 = 12;
D3 = 6;
H = L / 2;

rotate([180, 0, 0])
difference() {
    union() {
        cylinder(d1 = D - 2 * (L - L3 - L1) / 10, d2 = D, h = L - L3 - L1, $fn = 100);
        translate([0, 0, L - L1 - L3])
            cylinder(d = D2, h = L3, $fn = 100);
        translate([0, 0, L - L1])
            cylinder(d = D1, h = L2, $fn = 100);
        translate([0, 0, L - L1 + L2])
            cylinder(d1 = D1, d2 = D1 - 2 * (L1 - L2) * tan(30), h = L1 - L2, $fn = 100);
    }
    union() {
        cylinder(d = d, h = L, $fn = 100);
        cylinder(d = D3, h = H, $fn = 100);
        translate([0, 0, H])
            cylinder(d1 = D3, d2 = 0, h = D3 / 2 / tan(45), $fn = 100);
        translate([0, 0, L / 2 + 4])
            cube([0.8, D1, L], center = true);
        translate([0, 0, L / 2 + 4])
            cube([D1, 0.8, L], center = true);
        //cube([40, 40, 40]);
    }
}