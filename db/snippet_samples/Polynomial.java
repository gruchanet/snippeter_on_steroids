package mo.calc;

import java.util.List;

import org.paukov.combinatorics.Factory;
import org.paukov.combinatorics.Generator;
import org.paukov.combinatorics.ICombinatoricsVector;

public class Polynomial { // Interpolating Newton's method
	private Node node;
	private double[] b;
	private double[] W; // polynomial

	public Polynomial(Node node) {
		if (!node.isEmpty()) {
			this.node = node;
			b = new double[node.getSize()];
			W = new double[node.getSize()];
		}
		else
			System.err.println("Error in [" + this.getClass().getSimpleName() +"]Constructor: Node is null!");
	}

	/**
	 * <b>Initial calculation</b>
	 * Calculates <b>b</b>[] and <b>W</b>[] coefficients
	 */
	public void init() {
		calculateB();
		calculateCoeffs();
	}

	/**
	 * Set <b>x</b> into polynomial and calculate it
	 */
	public double calculatePolynomial(Integer x) {
		double P = W[0]; // P = 0?

		if (W.length > 0)
			for (int i = 1; i < W.length; i++)
				P += W[i]*Math.pow(x, i);

		return P;
	}

	/**
	 * Extends Node(x[], y[]) by adding new Node(<b>x</b>, <b>y</b>) and calculate it
	 */
	public void extendNCalculate(Integer x, Integer y) {
		node.extend(x, y);
		double[] tempB = new double[b.length + 1];
		double[] tempW = new double[W.length + 1];
		System.arraycopy(b, 0, tempB, 0, b.length);
		System.arraycopy(W, 0, tempW, 0, W.length);
		b = tempB;
		W = tempW;

		b[b.length - 1] = (node.getY(node.getSize() - 1) - calculatePolynomial(node.getX(node.getSize() - 1))) / calcProduct(node.getSize() - 1, node.getSize() - 2);
		calculateCoeffs();
	}

	public void printPolynomial() {
		String s = "P(x) = " + W[0];
		if (W.length > 0) {
			for (int i = 1; i < W.length; i++) {
				if (W[i] > 0)
					s = s.concat(" + " + W[i]);
				else if (W[i] < 0)
					s = s.concat(" - " + -W[i]);

				if (W[i] != 0 && i > 1)
					s = s.concat("x^" + i);
				else if (W[i] != 0 && i == 1)
					s = s.concat("x");
			}
		}
		System.out.println(s);
	}

	public void printB() {
		String s = "b[] = {";
		for (int i = 0; i < b.length - 1; i++)
			s = s.concat(b[i] + ", ");
		s = s.concat(b[b.length - 1] + "}");
		System.out.println(s);
	}

	public void printCoeffs() {
		String s = "W[] = {";
		for (int i = 0; i < W.length - 1; i++)
			s = s.concat(W[i] + ", ");
		s = s.concat(W[W.length - 1] + "}");
		System.out.println(s);
	}

	public String getTex() {
		String s = "\\\\x[\\medspace] = [";

		for (int i = 0; i < node.getSize() - 1; i++)
			s = s.concat(node.getX(i) + ",\\medspace");
		s = s.concat(node.getX(b.length - 1) + "]\\\\y[\\medspace] = [");
		for (int i = 0; i < node.getSize() - 1; i++)
			s = s.concat(node.getY(i) + ",\\medspace");
		s = s.concat(node.getY(b.length - 1) + "]\\\\b[\\medspace] = [");
		for (int i = 0; i < b.length - 1; i++)
			s = s.concat(b[i] + ",\\medspace");
		s = s.concat(b[b.length - 1] + "]\\\\W[\\medspace] = [");
		for (int i = 0; i < W.length - 1; i++)
			s = s.concat(W[i] + ",\\medspace");
		s = s.concat(W[W.length - 1] + "]\\\\P(x) = " + W[0]);

		if (W.length > 0) {
			for (int i = 1; i < W.length; i++) {
				if (W[i] > 0)
					s = s.concat(" + " + W[i]);
				else if (W[i] < 0)
					s = s.concat(" - " + -W[i]);

				if (W[i] != 0 && i > 1)
					s = s.concat("x^" + i);
				else if (W[i] != 0 && i == 1)
					s = s.concat("x");
			}
		}

		return s;
	}

	/**
	 * Calculates <b>b</b>[]
	 */
	private void calculateB() {
		for (int i = 0; i < b.length; i++)
			b[i] = (node.getY(i) - calcSeries(i, i-1)) / calcProduct(i, i-1);
	}

	/**
	 * Calculates <b>W</b>[] coefficients
	 */
	private void calculateCoeffs() {
		for (int i = 0; i < W.length; i++)
			W[i] = calcCoeff(i, W.length - 1);
	}

	/**
	 * Summing => b0 + b1(xi - x0) + ...
	 */
	private double calcSeries(int iAtX, int i) {
		if (i == -1)
			return 0;
		else
			return (b[i] * calcProduct(iAtX, i-1)) + calcSeries(iAtX, --i);
	}

	/**
	 * Multiplying => (xi - x0)(xi - x1)(xi - x2)...
	 */
	private double calcProduct(int iAtX, int i) {
		if (i == -1)
			return 1;
		else
			return (node.getX(iAtX) - node.getX(i)) * calcProduct(iAtX, --i);
	}

	/**
	 * Calculates <b>W</b>[<b>i</b>]<br>
	 * <b>i</b> is index
	 */
	private double calcCoeff(int degree, int i) {
		if (degree == i)
			return b[i];
		else
			return b[i] * calcBrackets(degree, i-1) + calcCoeff(degree, --i);
	}

	/**
	 * eg. (x2 - x1) + (x2 - x1) + (x1 - x0)
	 */
	private int calcBrackets(int degree, int i) {
		if (i == -1)
			return 1;
		else if (degree == 0)
			return -node.getX(i) * calcBrackets(degree, --i);
		else
			return calcSumOfProducts(degree, i+1);
	}

	/**
	 * Extension of method <b>calcBracets</b>
	 */
	private int calcSumOfProducts(int degree, int i) {
		ICombinatoricsVector<Integer> vector = Factory.createVector(node.getXElements(i));
		Generator<Integer> generator = Factory.createSimpleCombinationGenerator(vector, i - degree);
		List<ICombinatoricsVector<Integer>> temp = generator.generateAllObjects();

		int sum = 0;
		for (int m = 0; m < temp.size(); m++) {
			int mul = 1;
			for (int n = 0; n < temp.get(m).getSize(); n++) {
				mul *= -temp.get(m).getValue(n);
			}
			sum += mul;
		}

		return sum;
	}
}
