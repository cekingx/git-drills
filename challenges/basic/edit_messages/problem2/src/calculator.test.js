const Calculator = require('./calculator');

describe('Calculator', () => {
    let calc;

    beforeEach(() => {
        calc = new Calculator();
    });

    test('should add two numbers', () => {
        expect(calc.add(2, 3)).toBe(5);
    });

    test('should subtract two numbers', () => {
        expect(calc.subtract(5, 3)).toBe(2);
    });

    test('should multiply two numbers', () => {
        expect(calc.multiply(4, 3)).toBe(12);
    });

    test('should divide two numbers', () => {
        expect(calc.divide(10, 2)).toBe(5);
    });

    test('should throw error when dividing by zero', () => {
        expect(() => calc.divide(10, 0)).toThrow('Cannot divide by zero');
    });

    test('should calculate power', () => {
        expect(calc.power(2, 3)).toBe(8);
    });
});
