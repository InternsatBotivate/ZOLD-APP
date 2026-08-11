# Walkthrough - Clear Inputs on Metal Switch

I have updated the `BuySellController` to clear the "Enter Amount" and "Grams" fields whenever the user switches between Gold and Silver (or between Buy and Sell). This ensures a clean state when starting a new calculation for a different metal or transaction type.

## Changes Made

### Buy/Sell Module

#### [BuySellController](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/buy_sell/controllers/buy_sell_controller.dart)
- Modified `_refreshData()` to clear `amountController` and `gramsController` when the metal type or action type changes.
- Reset `metalGrams`, `totalAmount`, `rangeError`, and `isInsufficientBalance` state variables to their initial values during the refresh.
- Added a guard in `_refreshData()` to skip `_syncInputs()` if the controllers are empty, preventing accidental repopulation of zero values into the text fields.

## Verification Results

### Manual Verification
- **Metal Switch**: Select Gold, enter an amount, then switch to Silver. The amount and grams fields are now automatically cleared.
- **Action Switch**: Enter an amount in "Buy" mode, then switch to "Sell" mode. The fields are cleared.
- **State Consistency**: Switching back and forth resets the validation errors (like "Minimum purchase amount") until new values are entered.
