public query func sort(nums : [Int]) : async [Int] {
    var nums_temp = Array.thaw<Int>(nums);
    quick_sort(nums_temp, 0, nums_temp.size()-1);
    return Array.freeze<Int>(nums_temp);
  };
