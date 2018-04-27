echo "\n" > ./nl.sol
cat ./Owned.sol ./nl.sol ./SafeMath.sol ./nl.sol ./ERC20Token.sol ./nl.sol ./TeleToken.sol > temp.sol
grep -v "import" temp.sol > temp1.sol && mv temp1.sol temp.sol
grep -v "pragma solidity" temp.sol > temp1.sol && mv temp1.sol temp.sol
echo "pragma solidity ^0.4.16;" > ./TeleTokenFull.sol
cat temp.sol >> ./TeleTokenFull.sol
unlink temp.sol
unlink nl.sol