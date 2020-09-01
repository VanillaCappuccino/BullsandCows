//
//  ProcessedNumber.swift
//  Bulls and Cows
//
//  Created by Mete Hergül on 31.08.2020.
//  Copyright © 2020 CSTECH. All rights reserved.
//

import Foundation
import UIKit

class ProcessedNumber
{
    let numb, mode: Int
    init(numb:Int, mode: Int)
    {
        self.numb = numb
        self.mode = mode
    }
    
    func extract(numb:Int) -> [Int]
    {
        var temp: [Int] = []
        var store: Int = numb
        
        while store > 0
        {
            let m = store % 10
            temp.append(m)
            store -= m
            store /= 10
        }
        temp.reverse()
        return temp
    }

    //------------------------------------------------------------------------------

    func compare(origin:Int,numbers:inout[Int],plus:Int,minus:Int) -> [Int]
    {
        let origin_arr: [Int] = extract(numb:origin)
        for num in numbers
        {
            let temp:[Int] = extract(numb:num)
            var p = 0
            var m = 0
            for i in 0..<temp.count
            {
                if temp[i] == origin_arr[i]
                {
                    p += 1
                }
                else if origin_arr.contains(temp[i])
                {
                    if temp.firstIndex(of: origin_arr[i]) != i
                    {
                        m += 1
                    }
                }
            }
            
            if p != plus || m != minus
            {
                let ind = numbers.firstIndex(of: num)!
                numbers.remove(at: ind)
            }
        }

        return numbers
    }

    //------------------------------------------------------------------------------
    
    func easyCompare(origin:Int,numbers:inout[Int],plus:Int,minus:Int) -> [Int]
    {
        let origin_arr: [Int] = extract(numb:origin)
        var turner: Int = 0
        for num in numbers
        {
            let temp:[Int] = extract(numb:num)
            var p = 0
            var m = 0
            for i in 0..<temp.count
            {
                if temp[i] == origin_arr[i]
                {
                    p += 1
                }
                else if origin_arr.contains(temp[i])
                {
                    if temp.firstIndex(of: origin_arr[i]) != i
                    {
                        m += 1
                    }
                }
            }
            turner += 1
            
            if (p != plus || m != minus) && turner % 4 != 0
            {
                let ind = numbers.firstIndex(of: num)!
                numbers.remove(at: ind)
            }
        }

        return numbers
    }
    
    //------------------------------------------------------------------------------

    func condcheck(numb:Int,mode:Int) -> Bool
    {
        let temp:[Int] = extract(numb:numb)
        var t:[Int] = []
        for i in temp
        {
            if (t.contains(i)) == false
            {
                t.append(i)
            }
        }
        if t.count != mode
        {
            return false
        }
        return true
    }

    //------------------------------------------------------------------------------

    func expo(numb:Int,power:Int) -> Int
    {
        var prod: Int = 1
        var pow: Int = power
        while pow > 0
        {
            prod *= numb
            pow -= 1
        }
        return prod
    }

    //------------------------------------------------------------------------------

    func numgen(mode:Int) -> [Int]
    {
        var numbers:[Int] = []
        let lower: Int = expo(numb:10,power:mode - 1)
        let upper: Int = expo(numb:10,power:mode)
        for i in lower..<upper
        {
            if condcheck(numb:i,mode:mode) == true
            {
                numbers.append(i)
            }
        }
        return numbers
    }

    //------------------------------------------------------------------------------
    
    func randnum(space: [Int]) -> Int
    {
        var ran: Int = 1111
        if let m: Int = space.randomElement()
        {
            ran = m
        }
        return ran
    }


//------------------------------------------------------------------------------

    func plusminus(origin:Int,number:Int) -> [Int]
    {
        let origin_arr: [Int] = extract(numb:origin)
        let temp: [Int] = extract(numb:number)
        var p = 0
        var m = 0
        for i in 0..<temp.count
        {
            if temp[i] == origin_arr[i]
            {
                p += 1
            }
            else if origin_arr.contains(temp[i])
            {
                if temp.firstIndex(of: origin_arr[i]) != i
                {
                    m += 1
                }
            }
        }
        return [p,m]
    }
}
