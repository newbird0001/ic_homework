  func apart(nums:[var Int],left:Nat,right:Nat):Nat{
    let pivot = nums[left];var l = left;var r = right;
    while(l < r)
    {
      while(nums[r] >= pivot and l != r){r-=1;};
      nums[l] := nums[r];
      while(nums[l] < pivot and l != r){l+=1;};
      nums[r] := nums[l];
    };
    nums[l] := pivot;
    return l;
  };

  func quick_sort(nums : [var Int],left:Nat,right:Nat) : () {
    let pivot = apart(nums,left, right);
    if(pivot > left + 1){quick_sort(nums,left,pivot - 1);};
    if(right > pivot + 1){quick_sort(nums,pivot + 1, right);};
    return;
  };
