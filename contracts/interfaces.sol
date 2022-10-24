interface IERC20Lite {
    
    function transfer(address to, uint256 value) external returns (bool);
    function burn(address from, uint256 value) external;
    function mint(address to, uint256 value) external; 

}
interface ERC1155Like {
    function balanceOf(address _owner, uint256 _id) external view returns (uint256);
    function mint(address to, uint256 id, uint256 amount) external;
    function burn(address from, uint256 id, uint256 amount) external;
    function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes memory _data) external;
}
