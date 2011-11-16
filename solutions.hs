module Main where

import Control.Arrow ((&&&))
import Data.Array
import Data.Function (on)
import Data.Maybe (listToMaybe)
import Data.List (tails, maximumBy, find, subsequences, group, sort)

main :: IO ()
main = print solution

-- 1 Add all the natural numbers below one thousand that are multiples of 3 or 5.	
solution1 = foldl1 (+) [x | x <- [1..999], x `divs` 3 || x `divs` 5]

k `divs` n = n `mod` k == 0




-- 2 By considering the terms in the Fibonacci sequence whose values do not exceed four million, find the sum of the even-valued terms.	
solution2 = foldl1 (+) . takeWhile (<=4000000) . filter (`divs` 2) $ fibs

fibs = 1 : 2 : zipWith (+) fibs (tail fibs)


-- 3 Find the largest prime factor of a composite number.	
solution3 = maximum . factors $ 600851475143

factors n = case factor n of
  Just k -> k : factors (n `div` k)
  Nothing -> [n]

factor n = listToMaybe . filter (`divs` n) . takeWhile (\x -> x*x <= n) $ [2..]


-- 4 Find the largest palindrome made from the product of two 3-digit numbers.	
solution4 = maximum [x | a <- [100..999], b <- [100..999], let x = a*b, let dx = digits x, dx == reverse dx]

digits :: Int -> [Int]
digits x | x >= 10 = let (d, m) = x `divMod` 10 in (m : digits d) 
digits x | otherwise = [x]


-- 5 What is the smallest number divisible by each of the numbers 1 to 20?	

-- *Main Data.List> map factors [1..20]
-- [[1],[2],[3],[2,2],[5],[2,3],[7],[2,2,2],[3,3],[2,5],[11],[2,2,3],[13],[2,7],[3,5],[2,2,2,2],[17],[2,3,3],[19],[2,2,5]]
-- we need to take the max occurences in one list of each prime factor
solution5 = 2*2*2*2*3*3*5*7*11*13*17*19


-- 6 What is the difference between the sum of the squares and the square of the sums?	
solution6 = sq (sum xs) - sum (map sq xs)
  where sq x = x*x
        xs = [1..100]


-- 7 Find the 10001st prime.	
solution7 = primes !! (10001 - 1)

primes = filter (\x -> factor x == Nothing) [2..]


-- 8 Discover the largest product of five consecutive digits in the 1000-digit number.
solution8 = maximum . map product . map (take 5) . tails $ n8Digits

n8 = "7316717653133062491922511967442657474235534919493496983520312774506326239578318016984801869478851843858615607891129494954595017379583319528532088055111254069874715852386305071569329096329522744304355766896648950445244523161731856403098711121722383113622298934233803081353362766142828064444866452387493035890729629049156044077239071381051585930796086670172427121883998797908792274921901699720888093776657273330010533678812202354218097512545405947522435258490771167055601360483958644670632441572215539753697817977846174064955149290862569321978468622482839722413756570560574902614079729686524145351004748216637048440319989000889524345065854122758866688116427171479924442928230863465674813919123162824586178664583591245665294765456828489128831426076900422421902267105562632111110937054421750694165896040807198403850962455444362981230987879927244284909188845801561660979191338754992005240636899125607176060588611646710940507754100225698315520005593572972571636269561882670428252483600823257530420752963450"

n8Digits = map (read . (:[])) n8 :: [Int]


-- 9 Find the only Pythagorean triplet, {a, b, c}, for which a + b + c = 1000.
solution9 = let [(x, y, z)] = triplets 1000 in x*y*z

triplets k = [(a, b, c) | a <- [1..k-1], b <- [1..k-1], let c = k - a - b, a < b, b < c, a*a + b*b == c*c]


-- 10 Calculate the sum of all the primes below two million.

-- On my computer, this runs in a few seconds when compiled -O2
solution10 = sum . takeWhile (<2000000) $ primes


-- 20 What is the greatest product of four adjacent numbers on the same straight line in the 20 by 20 grid?
solution11 = maximum . map (product . map (a11!)) $ (rows ++ columns ++ diags_rd ++ diags_ru)
rows = onSquare ((0, 0), (20-4, 20-1)) $ \(x, y) -> [(x', y) | x' <- [x..x+4-1]]
columns = map (map (\(a, b)->(b, a))) rows
diags_rd = onSquare ((0, 0), (20-4, 20-4)) $ \(x, y) -> [(x + i, y + i) | i <- [0..4-1]]
diags_ru = map (map (\(a, b)->(a, 20 - 1 - b))) diags_rd
onSquare r f = map f $ range r

a11string = "\
\08 02 22 97 38 15 00 40 00 75 04 05 07 78 52 12 50 77 91 08\n\
\49 49 99 40 17 81 18 57 60 87 17 40 98 43 69 48 04 56 62 00\n\
\81 49 31 73 55 79 14 29 93 71 40 67 53 88 30 03 49 13 36 65\n\
\52 70 95 23 04 60 11 42 69 24 68 56 01 32 56 71 37 02 36 91\n\
\22 31 16 71 51 67 63 89 41 92 36 54 22 40 40 28 66 33 13 80\n\
\24 47 32 60 99 03 45 02 44 75 33 53 78 36 84 20 35 17 12 50\n\
\32 98 81 28 64 23 67 10 26 38 40 67 59 54 70 66 18 38 64 70\n\
\67 26 20 68 02 62 12 20 95 63 94 39 63 08 40 91 66 49 94 21\n\
\24 55 58 05 66 73 99 26 97 17 78 78 96 83 14 88 34 89 63 72\n\
\21 36 23 09 75 00 76 44 20 45 35 14 00 61 33 97 34 31 33 95\n\
\78 17 53 28 22 75 31 67 15 94 03 80 04 62 16 14 09 53 56 92\n\
\16 39 05 42 96 35 31 47 55 58 88 24 00 17 54 24 36 29 85 57\n\
\86 56 00 48 35 71 89 07 05 44 44 37 44 60 21 58 51 54 17 58\n\
\19 80 81 68 05 94 47 69 28 73 92 13 86 52 17 77 04 89 55 40\n\
\04 52 08 83 97 35 99 16 07 97 57 32 16 26 26 79 33 27 98 66\n\
\88 36 68 87 57 62 20 72 03 46 33 67 46 55 12 32 63 93 53 69\n\
\04 42 16 73 38 25 39 11 24 94 72 18 08 46 29 32 40 62 76 36\n\
\20 69 36 41 72 30 23 88 34 62 99 69 82 67 59 85 74 04 36 16\n\
\20 73 35 29 78 31 90 01 74 31 49 71 48 86 81 16 23 57 05 54\n\
\01 70 54 71 83 51 54 69 16 92 33 48 61 43 52 01 89 19 67 48"

a11 = listArray ((0, 0), (20-1, 20-1)) . concatMap (map read . words) . lines $ a11string


-- 12 What is the value of the first triangle number to have over five hundred divisors?
solution12 = s12 500

s12 k = find ((>= k) . length . divisors) triangleNumbers

triangleNumbers = scanl1 (+) [1..]

divisors k = map head . group . sort . map product . subsequences . factors $ k


solution = solution12
