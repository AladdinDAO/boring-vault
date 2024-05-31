// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.21;

import {BaseMerkleRootGenerator} from "resources/BaseMerkleRootGenerator.sol";
import {FixedPointMathLib} from "@solmate/utils/FixedPointMathLib.sol";
import {ERC20} from "@solmate/tokens/ERC20.sol";
import {Strings} from "lib/openzeppelin-contracts/contracts/utils/Strings.sol";
import {ERC4626} from "@solmate/tokens/ERC4626.sol";

/**
 *  source .env && forge script script/CreateTestMerkleRoot.s.sol:CreateTestMerkleRootScript --rpc-url $MAINNET_RPC_URL
 */
contract CreateTestMerkleRootScript is BaseMerkleRootGenerator {
    using FixedPointMathLib for uint256;

    address public boringVault = 0xf2b27554d618488f28023467d3F9656c472ea22e;
    address public managerAddress = 0x4180D80018055158cf608A7A7Eb5582C7a0135E8;
    address public accountantAddress = 0xE4100F1Cf42C7CD6E5Cac69002eeD2F1c6d68704;
    address public rawDataDecoderAndSanitizer = address(0);

    address public itbKilnOperatorPositionManager = 0xc31BDE60f00bf1172a59B8EB699c417548Bce0C2;
    address public itbP2POperatorPositionManager = 0x3034dA3ff55466612847a490B6a8380cc6E22306;
    address public itbDecoderAndSanitizer = 0xF87F3Cf3b1bC0673e037c41b275B4300e1eCF739;

    function setUp() external {}

    /**
     * @notice Uncomment which script you want to run.
     */
    function run() external {
        generateTestStrategistMerkleRoot();
    }

    function _addLeafsForITBEigenLayerPositionManager(
        ManageLeaf[] memory leafs,
        address positionManager,
        ERC20[] memory tokens,
        address _strategyManager,
        address _delegationManager,
        address liquidStaking,
        address underlying,
        address delegateTo
    ) internal {
        // acceptOwnership
        leafIndex++;
        leafs[leafIndex] = ManageLeaf(
            positionManager,
            false,
            "acceptOwnership()",
            new address[](0),
            string.concat("Accept ownership of the ITB Contract: ", vm.toString(positionManager)),
            itbDecoderAndSanitizer
        );
        // Transfer all tokens to the ITB contract.
        for (uint256 i; i < tokens.length; i++) {
            leafIndex++;
            leafs[leafIndex] = ManageLeaf(
                address(tokens[i]),
                false,
                "transfer(address,uint256)",
                new address[](1),
                string.concat("Transfer ", tokens[i].symbol(), " to ITB Contract: ", vm.toString(positionManager)),
                itbDecoderAndSanitizer
            );
            leafs[leafIndex].argumentAddresses[0] = positionManager;
        }
        // Approval strategy manager to spend all tokens.
        for (uint256 i; i < tokens.length; i++) {
            leafIndex++;
            leafs[leafIndex] = ManageLeaf(
                positionManager,
                false,
                "approveToken(address,address,uint256)",
                new address[](2),
                string.concat("Approve Strategy Manager to spend ", tokens[i].symbol()),
                itbDecoderAndSanitizer
            );
            leafs[leafIndex].argumentAddresses[0] = address(tokens[i]);
            leafs[leafIndex].argumentAddresses[1] = _strategyManager;
        }
        // Withdraw all tokens
        for (uint256 i; i < tokens.length; i++) {
            leafIndex++;
            leafs[leafIndex] = ManageLeaf(
                positionManager,
                false,
                "withdraw(address,uint256)",
                new address[](1),
                string.concat("Withdraw ", tokens[i].symbol(), " from ITB Contract: ", vm.toString(positionManager)),
                itbDecoderAndSanitizer
            );
            leafs[leafIndex].argumentAddresses[0] = address(tokens[i]);

            leafIndex++;
            leafs[leafIndex] = ManageLeaf(
                positionManager,
                false,
                "withdrawAll(address)",
                new address[](1),
                string.concat(
                    "Withdraw all ", tokens[i].symbol(), " from the ITB Contract: ", vm.toString(positionManager)
                ),
                itbDecoderAndSanitizer
            );
            leafs[leafIndex].argumentAddresses[0] = address(tokens[i]);
        }
        // Update strategy manager.
        leafIndex++;
        leafs[leafIndex] = ManageLeaf(
            positionManager,
            false,
            "updateStrategyManager(address)",
            new address[](1),
            "Update the strategy manager",
            itbDecoderAndSanitizer
        );
        leafs[leafIndex].argumentAddresses[0] = _strategyManager;
        // Update Delegation Manager.
        leafIndex++;
        leafs[leafIndex] = ManageLeaf(
            positionManager,
            false,
            "updateDelegationManager(address)",
            new address[](1),
            "Update the delegation manager",
            itbDecoderAndSanitizer
        );
        leafs[leafIndex].argumentAddresses[0] = _delegationManager;
        // Update position config.
        leafIndex++;
        leafs[leafIndex] = ManageLeaf(
            positionManager,
            false,
            "updatePositionConfig(address,address,address)",
            new address[](3),
            "Update the position config",
            itbDecoderAndSanitizer
        );
        leafs[leafIndex].argumentAddresses[0] = liquidStaking;
        leafs[leafIndex].argumentAddresses[1] = underlying;
        leafs[leafIndex].argumentAddresses[2] = delegateTo;
        // Delegate
        leafIndex++;
        leafs[leafIndex] =
            ManageLeaf(positionManager, false, "delegate()", new address[](0), "Delegate", itbDecoderAndSanitizer);
        // Deposit
        leafIndex++;
        leafs[leafIndex] = ManageLeaf(
            positionManager, false, "deposit(uint256,uint256)", new address[](0), "Deposit", itbDecoderAndSanitizer
        );
        // Start Withdrawal
        leafIndex++;
        leafs[leafIndex] = ManageLeaf(
            positionManager,
            false,
            "startWithdrawal(uint256)",
            new address[](0),
            "Start Withdrawal",
            itbDecoderAndSanitizer
        );
        // Complete Withdrawal
        leafIndex++;
        leafs[leafIndex] = ManageLeaf(
            positionManager,
            false,
            "completeWithdrawal(uint256,uint256)",
            new address[](0),
            "Complete Withdrawal",
            itbDecoderAndSanitizer
        );
        // Complete Next Withdrawal
        leafIndex++;
        leafs[leafIndex] = ManageLeaf(
            positionManager,
            false,
            "completeNextWithdrawal(uint256)",
            new address[](0),
            "Complete Next Withdrawal",
            itbDecoderAndSanitizer
        );
        // Complete Next Withdrawals
        leafIndex++;
        leafs[leafIndex] = ManageLeaf(
            positionManager,
            false,
            "completeNextWithdrawals(uint256)",
            new address[](0),
            "Complete Next Withdrawals",
            itbDecoderAndSanitizer
        );
        // Override Withdrawal Indexes
        leafIndex++;
        leafs[leafIndex] = ManageLeaf(
            positionManager,
            false,
            "overrideWithdrawalIndexes(uint256,uint256)",
            new address[](0),
            "Override Withdrawal Indexes",
            itbDecoderAndSanitizer
        );
        // Assemble
        leafIndex++;
        leafs[leafIndex] = ManageLeaf(
            positionManager, false, "assemble(uint256)", new address[](0), "Assemble", itbDecoderAndSanitizer
        );
        // Disassemble
        leafIndex++;
        leafs[leafIndex] = ManageLeaf(
            positionManager,
            false,
            "disassemble(uint256,uint256)",
            new address[](0),
            "Disassemble",
            itbDecoderAndSanitizer
        );
        // Full Disassemble
        leafIndex++;
        leafs[leafIndex] = ManageLeaf(
            positionManager,
            false,
            "fullDisassemble(uint256)",
            new address[](0),
            "Full Disassemble",
            itbDecoderAndSanitizer
        );
    }

    function generateTestStrategistMerkleRoot() public {
        updateAddresses(boringVault, rawDataDecoderAndSanitizer, managerAddress, accountantAddress);

        ManageLeaf[] memory leafs = new ManageLeaf[](64);

        // TODO Currently there is no leafs for fee claiming.

        // ========================== ITB Eigen Layer Kiln Position Manager ==========================
        ERC20[] memory tokens = new ERC20[](1);
        tokens[0] = METH;
        _addLeafsForITBEigenLayerPositionManager(
            leafs,
            itbKilnOperatorPositionManager,
            tokens,
            strategyManager,
            delegationManager,
            mETHStrategy,
            address(METH),
            0x1f8C8b1d78d01bCc42ebdd34Fae60181bD697662
        );

        // ========================== ITB Eigen Layer P2P Position Manager ==========================
        _addLeafsForITBEigenLayerPositionManager(
            leafs,
            itbKilnOperatorPositionManager,
            tokens,
            strategyManager,
            delegationManager,
            mETHStrategy,
            address(METH),
            0xDbEd88D83176316fc46797B43aDeE927Dc2ff2F5
        );

        bytes32[][] memory manageTree = _generateMerkleTree(leafs);

        string memory filePath = "./leafs/TestStrategistLeafs.json";

        _generateLeafs(filePath, leafs, manageTree[manageTree.length - 1][0], manageTree);
    }
}
