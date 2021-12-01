async function main() {
  const WhereInTheNFT_AllHandsIn_Drop1_Test = await ethers.getContractFactory("WhereInTheNFT_AllHandsIn_Drop1_Test")

  // Start deployment, returning a promise that resolves to a contract object
  const whereInTheNFT_AllHandsIn_Drop1_Test = await WhereInTheNFT_AllHandsIn_Drop1_Test.deploy(0, "https://test-wit-api.herokuapp.com/api/token/")
  console.log("Contract deployed to address:", whereInTheNFT_AllHandsIn_Drop1_Test.address)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
