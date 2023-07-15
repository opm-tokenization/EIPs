// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

interface IFund {

    function init(address _token, string calldata _fundName, address fmAddress, 
                uint8 _assetType, 
                string calldata _issuerName, 
                uint256 _targetAUM,
                uint128 _NAVLaunchPrice, string calldata _NAVEndPoint) external;

    /**
    * @dev Adds management fees for multiple addresses.
    * @param _address An array of addresses for which management fees will be set.
    * @param _fee An array of corresponding management fees.
    * onlyAgent modifier ensures that only authorized agents can call this function.
    * Checks if the length of _address is equal to the length of _fee, indicating valid input.
    * Iterates over each address and sets the corresponding management fee.
    * Assumes that managementFee mapping is already initialized.
    */
    function addUserManagementFee(address[] calldata _address, uint256[] calldata _fee) external;

    /**
    @dev Internal function to add dividends for a specific address.
    @param _address The address for which dividends will be added.
    @param _dividend The amount of dividends to be added.
    @param _key The key indicating the type of dividends: 0 for Token, 1 for StableCoin, and any other value for Fiat.
    Checks the value of _key to determine the type of dividends to add.
    If _key is 0, sets the Token dividends for the address.
    If _key is 1, sets the StableCoin dividends for the address.
    If _key is any other value, sets the Fiat dividends for the address.
    Assumes that the dividend mapping is already initialized.
    This function is internal and can only be called within the contract.
    */
    function _addUserDividend(address _address, uint256 _dividend, uint8 _key) external;

    /**
    @dev Sets the APIConsumer contract address.
    @param _Consumer The address of the APIConsumer contract.
    onlyAgent modifier ensures that only authorized agents can call this function.
    Sets the apiConsumer variable with the provided address.
    */
    function setConsumer(address _Consumer) external;

    /**
    @dev Retrieves the management fee for a specific user address.
    @param _userAddress The address of the user.
    @return The management fee associated with the user address.
    This function is callable externally and returns the management fee for the specified user address.
    */
    function getManagementFee(address _userAddress) external view returns(uint256);

    /**
    @dev Calculates and returns the Assets Under Management (AUM) of the fund.
    Multiplies the circulating supply by the latest Net Asset Value (NAV) price to calculate the AUM.
    Assumes that the NAVLatestPrice and token variables are already initialized.
    Returns the calculated AUM.
    This function is callable externally.
    */
    function getAUM() external returns (uint256);

    /**
    @dev Retrieves the latest Net Asset Value (NAV) price from the APIConsumer contract.
    Updates the NAVLatestPrice variable with the retrieved value.
    Returns the updated NAVLatestPrice.
    Assumes that the apiConsumer variable is already initialized.
    This function is callable externally.
    */
    function getNAV() external returns (uint256);

    /**
    @dev Updates the address of the fund manager.
    @param _newFundManager The new address of the fund manager.
    onlyAgent modifier ensures that only authorized agents can call this function.
    Requires that the new fund manager address is not the zero address.
    Updates the fundManagerAddress variable with the new address.
    */
    function updateFundManager(address _newFundManager) external;

    /**
    @dev Updates the term of the fund.
    @param _newTerm The new term value for the fund.
    onlyAgent modifier ensures that only authorized agents can call this function.
    Requires that the new term is greater than 0.
    Updates the termOfFund variable with the new term value.
    */
    function updateTerm(uint256 _newTerm) external;

    /**
    @dev Updates the currency of the fund.
    @param _newCurrency The new currency for the fund.
    onlyAgent modifier ensures that only authorized agents can call this function.
    Updates the fundCurrency variable with the new currency value.
    */
    function updateFundCurrency(string calldata _newCurrency) external;

    /**
    @dev Updates the dividend cycle of the fund.
    @param _newCycle The new dividend cycle for the fund.
    onlyAgent modifier ensures that only authorized agents can call this function.
    Requires that the new dividend cycle is greater than 0.
    Updates the dividendCycle variable with the new cycle value.
    */
    function updateDividendCycle(uint256 _newCycle) external;

    /**
    @dev Updates the Internal Rate of Return (IRR) of the fund.
    @param _newIRR The new IRR value for the fund.
    onlyAgent modifier ensures that only authorized agents can call this function.
    Updates the iRR variable with the new IRR value.
    */
    function updateIRR(uint _newIRR) external;

    /**
    @dev Updates the management fees for a specific user address.
    @param _userAddress The address of the user for which the management fees will be updated.
    @param _updatedFees The new management fees for the user.
    onlyAgent modifier ensures that only authorized agents can call this function.
    Requires that the user address is not the zero address.
    Updates the managementFee mapping for the specified user address with the new fees.
    */
    function updateManagementFees(address _userAddress, uint256 _updatedFees) external;

    /**
    @dev Updates the API endpoint for retrieving the Net Asset Value (NAV) data.
    @param _newEndPoint The new API endpoint for NAV data.
    onlyAgent modifier ensures that only authorized agents can call this function.
    Calls the updateEndpoint() function of the APIConsumer contract to update the endpoint.
    Assumes that the apiConsumer variable is already initialized.
    */
    function updateNAVEndPoint(string calldata _newEndPoint) external;

    /**
    @dev Retrieves the address of the stablecoin at the specified index.
    @param coin The index of the stablecoin.
    @return stableCoin The address of the stablecoin at the specified index.
    Calls the getStableCoin() function of the ITokenFactory contract to get the stablecoin address.
    Assumes that the factory variable is already initialized.
    This function is callable externally and returns the address of the stablecoin.
    */
    function getStableCoin(uint8 coin) external view returns(address stableCoin);

    /**
    @dev Shares dividends with multiple addresses.
    @param _address An array of addresses to receive dividends.
    @param _dividend An array of corresponding dividend amounts.
    @param _from The address from which the dividends are sent.
    @param _key An array of keys indicating the type of dividends: 0 for Token, 1 for StableCoin, and any other value for Fiat.
    @param coin The index of the stablecoin to use.
    onlyAgent modifier ensures that only authorized agents can call this function.
    Requires that the length of _address, _dividend, and _key arrays are the same.
    Retrieves the address of the stablecoin at the specified index.
    Iterates over each address and shares the corresponding dividends.
    If the key is 0, mints the token dividends to the address.
    If the key is 1, transfers the stablecoin dividends from _from address to the recipient address.
    Calls the _addUserDividend() function to add the dividends to the recipient's record.
    Assumes that the token, factory, and _addUserDividend() function are already initialized.
    */
    function shareDividend(address[] calldata _address, uint256[] calldata _dividend, address _from, uint8[] calldata _key, uint8 coin) external;

    /**
    @dev Distributes funds and burns tokens for multiple investors.
    @param _investors An array of investor addresses.
    @param _amount An array of corresponding fund amounts to distribute.
    @param _tokens An array of corresponding token amounts to burn.
    @param _from The address from which the funds are sent.
    @param coin The index of the stablecoin to use.
    onlyAgent modifier ensures that only authorized agents can call this function.
    Requires that the length of _investors, _amount, and _tokens arrays are the same.
    Retrieves the address of the stablecoin at the specified index.
    Iterates over each investor and performs the distribution and token burning.
    Burns the specified amount of tokens from the investor's balance.
    Transfers the corresponding amount of funds from _from address to the investor's address.
    Assumes that the token, factory, and TransferHelper.safeTransferFrom() function are already initialized.
    */
    function distributeAndBurn(address[] calldata _investors, uint256[] calldata _amount, uint256[] calldata _tokens, address _from, uint8 coin) external;

    /**
    @dev Rescues any ERC20 tokens accidentally sent to the contract.
    @param _tokenAddr The address of the ERC20 token to be rescued.
    @param _to The address to which the rescued tokens will be transferred.
    @param _amount The amount of tokens to be rescued.
    onlyAgent modifier ensures that only authorized agents can call this function.
    Uses the SafeERC20Upgradeable library to safely transfer the specified amount of tokens to the specified address.
    Assumes that the _tokenAddr is a valid ERC20 token address.
    This function is callable externally.
    */
    function rescueAnyERC20Tokens(address _tokenAddr, address _to, uint128 _amount) external;
}