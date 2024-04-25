// SPDX-License-Identifier: MIT

pragma solidity 0.8.25;

// 1. Que defina un balance inicial de 1000 tokens asignados al creador (owner).
// 2. Poder transferir tokens entre addresser (-from +to).
// 3. Verificar el balance de una cuenta.
// 4. Que solo el dueño del contrato  pueda agregar mas tokens a su balance.
// 5. Emitir un evento cuando se minteen tokens nuevos.
// 6. Emitir un evento cuando se transfieran tokens entre cuentas.
// 7. Revertir la transaccion si la cuenta no tiene suficientes fondos.
// * Usar mapping.

/// @title Concepts: Module 2 task 1
/// @author Juan Oliú
contract Module2Task1 {
    mapping(address => uint256) private balances;
    address public owner;
    uint256 public totalSupply;

    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Mint(address indexed to, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner is allowed to perform this action");
        _;
    }

    function mint(address to, uint256 amount) public onlyOwner {
        balances[to] += amount;
        totalSupply += amount;
        emit Mint(to, amount);
    }

    function transfer(address to, uint256 amount) public {
        require(to != address(0), "Avoid transfering tokens to address 0, those tokens will be burnt");
        require(to != owner, "The destinatary address cannot match the origin");
        
        address from = msg.sender;
        require(
            balances[from] <= amount,
            "Not enough funds on the sender balance to perform the transfer"
        );

        balances[from] -= amount;
        balances[to] += amount;
        emit Transfer(from, to, amount);
    }

    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }

    constructor() {
        owner = msg.sender;
        mint(msg.sender, 1000);
    }
}
