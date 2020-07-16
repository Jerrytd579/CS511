// Jerry Cheng & Andrew Chuah
// I pledge my honor that I have abided by the Stevens Honor System.
// 7/16/2020
public class Interval {
    private int x;
    private int y;
    
    public Interval(int x, int y) {
        this.x = x;
        this.y = y;
    }

    public int getX() {
        return this.x;
    }

    public int getY() {
         return this.y;
    }

    public String toString() {
        return "(" + this.x + ", " + this.y + ")";
    }
}