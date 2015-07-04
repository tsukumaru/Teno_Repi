import java.io.*;

class q1{
	public static void main(String[] args) throws IOException{ 
		BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
		
		System.out.println("IPアドレスを入力してください");
		String s = new String(br.readLine());

		if(check(s)) System.out.println("True");
		else System.out.println("False");
	}

	static boolean check(String ipv4){
		String[] nums = ipv4.split("\\.");
		if(nums.length == 4){
			for(int i = 0; i < nums.length; i++){
				int n;
				if(nums[i].charAt(0) == '0' && nums[i].length() != 1) return false;

				try {
					n = Integer.parseInt(nums[i]);
					if(n < 0 && n > 255) return false;
				} catch(NumberFormatException e) {
				  return false;
				}
			}
		}
		else return false;

		return true;
	}
}
