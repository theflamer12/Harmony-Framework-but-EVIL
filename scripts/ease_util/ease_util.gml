// =========================================================
// Sine easing
// =========================================================
function ease_in_sine(val)
{
	return 1 - cos((val * pi) / 2);
}

function ease_out_sine(val)
{
	return sin((val * pi) / 2);
}

function ease_in_out_sine(val)
{
	return -(cos(pi * val) - 1) / 2;
}

// =========================================================
// Quad easing
// =========================================================
function ease_in_quad(v) 
{
	return v * v;
}

function ease_out_quad(val)
{
	return 1 - (1 - val) * (1 - val);
}

function ease_in_out_quad(val)
{
	return val < 0.5 ? 2 * val * val : 1 - power(-2 * val + 2, 2) / 2;
}

// =========================================================
// Cubic easing
// =========================================================
function ease_in_cubic(val)
{
	return val * val * val;
}

function ease_out_cubic(val)
{
	return 1 - power(1 - val, 3);
}

function ease_in_out_cubic(val) 
{
	return val < 0.5 ? 4 * val * val * val : 1 - power(-2 * val + 2, 3) / 2;
}

// =========================================================
// Quart easing
// =========================================================
function ease_in_quart(val)
{
	return val * val * val * val;
}

function ease_out_quart(val) 
{
	return 1 - power(1 - val, 4);
}

function ease_in_out_quart(val) 
{
	return val < 0.5 ? 8 * val * val * val * val : 1 - power(-2 * val + 2, 4) / 2;
}

// =========================================================
// Quint easing
// =========================================================
function ease_in_quint(val)
{
	return val * val * val * val * val;
}

function ease_out_quint(val) 
{
	return 1 - power(1 - val, 5);
}

function ease_in_out_quint(val)
{
	return val < 0.5 ? 16 * val * val * val * val * val : 1 - power(-2 * val + 2, 5) / 2;
}

// =========================================================
// Expo easing
// =========================================================
function ease_in_expo(val) 
{
	return val == 0 ? 0 : power(2, 10 * val - 10);
}

function ease_out_expo(val) 
{
	return val == 1 ? 1 : 1 - power(2, -10 * val);
}

function ease_in_out_expo(val) 
{
	return ((val == 0) ? 0 : ((val == 1) ? 1 : ((val < 0.5) ? (power(2, 20 * val - 10) / 2) : ((2 - power(2, -20 * val + 10)) / 2))));
}

// =========================================================
// Circ easing
// =========================================================
function ease_in_circ(val)
{
	return 1 - sqrt(1 - power(val, 2));
}

function ease_out_circ(val)
{
	return sqrt(1 - power(val - 1, 2));
}

function ease_in_out_circ(val)
{
	return val < 0.5 ? (1 - sqrt(1 - power(2 * val, 2))) / 2 : (sqrt(1 - power(-2 * val + 2, 2)) + 1) / 2;
}

// =========================================================
// Back easing
// =========================================================
function ease_in_back(val)
{
	var c1 = 1.70158;
	var c3 = c1 + 1;
	return c3 * val * val * val - c1 * val * val;
}

function ease_out_back(val) 
{
	var c1 = 1.70158;
	var c3 = c1 + 1;
	return 1 + c3 * power(val - 1, 3) + c1 * power(val - 1, 2);
}

function ease_in_out_back(val)
{
	var c1 = 1.70158;
	var c2 = c1 * 1.525;
	return val < 0.5 ? (power(2 * val, 2) * ((c2 + 1) * 2 * val - c2)) / 2 : (power(2 * val - 2, 2) * ((c2 + 1) * (val * 2 - 2) + c2) + 2) / 2;
}

// =========================================================
// Elastic easing
// =========================================================
function ease_in_elastic(val)
{
	var c4 = (2 * pi) / 3;
	return ((val == 0) ? 0 : ((val == 1) ? 1 : (-power(2, 10 * val - 10) * sin((val * 10 - 10.75) * c4))));
}

function ease_out_elastic(val) 
{
	var c4 = (2 * pi) / 3;
	return power(2, -10 * val) * sin((val * 10 - 0.75) * c4) + 1;
}

function ease_in_out_elastic(val)
{
	var c5 = (2 * pi) / 4.5;
	return ((val == 0) ? 0 : ((val == 1) ? 1 : ((val < 0.5) ? (-(power(2, 20 * val - 10) * sin((20 * val - 11.125) * c5)) / 2) : ((power(2, -20 * val + 10) * sin((20 * val - 11.125) * c5)) / 2 + 1))));
}

// =========================================================
// Bounce easing
// =========================================================
function ease_in_bounce(val)
{
	return 1 - ease_out_bounce(1 - val);
}

function ease_out_bounce(val)
{
    var n1 = 7.5625;
    var d1 = 2.75;

    if (val < 1 / d1)
    {
        return n1 * val * val;
    }
    else if (val < 2 / d1)
    {
        val = val - 1.5 / d1;
        return n1 * val * val + 0.75;
    }
    else if (val < 2.5 / d1)
    {
        val = val - 2.25 / d1;
        return n1 * val * val + 0.9375;
    }
    else
    {
        val = val - 2.625 / d1;
        return n1 * val * val + 0.984375;
    }
}

function ease_in_out_bounce(val) 
{
	return val < 0.5 ? (1 - ease_out_bounce(1 - 2 * val)) / 2 : (1 + ease_out_bounce(2 * val - 1)) / 2;
}