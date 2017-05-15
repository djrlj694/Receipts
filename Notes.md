# Refactoring Ideas

## AppDelegate

* Remove the comment copyrights at the top of every file.
* Remove all of the empty templated methods.

## Global

* Everything should have `private` where they can.
* Consider moving `private` methods to bottom and grouping with `MARK://`.
* Lack of localization.

## ReceiptsListViewController

* Make a new object that can be the table view data source and delegate.
* Make a new object that can own the receipts and handle persistence.
* Remove the weak from the tableView outlet. Apple recommends strong outlet as of WWDC 2015.
* All the stuff in viewDidLoad should be broken down into their own self documenting methods.
	* configureTableView()
	* loadReceiptsFromDisk()
	* setupNotificationForAutosave()
* Add a deinit with a removeObserver call to mirror the setup
	* `NotificationCenter.default.removeObserver(self)`
	*  UIViewController will do this for you automatically.
* Consider removing the auto-row-deselection behavior and putting it in a protocol extension.
* Remove the memory warning if you aren't going to use it.
	* You may want to use it, see Receipt Model below.
* It's dangerous to use strings for the segue identifiers. Make an enum or something to symbolize them.
* When unpacking cells avoid the use of as!. If the cell type can not be matched we want a failure not a crash.
	* While we don't have analytics installed, it would be good use of them to report these things as non-crash error events.
* When dealing with table view cells and setting them up there are two historic implementation styles:
	* Have the cell expose the outlets to the views and push the responsibility onto the user of the cell, keeping the cell very dumb.
		* Problem: Could end up duplicating our efforts if we use the cell in multiple spots. Behavior could start to diverge. 
	* Have the caller pass in the model into the cell and the cell then sets all the labels and things relative to the model.
		* Problem: Having a ref to the model is dangerous, what if the model changes? Is the cell responsible to self update itself?
		* Problem: Can't use the cell for similar but different models.
		* Creates a coupling where if either the model or the cell changes, we are likely to have to edit both.
	* New idea: Pass in a simple struct that just has the data the cell needs.
		* Con: Little bit more code.
		* Pro: Improves testability.
		* Pro: No more model references.
* We should not be allocating formatters for every cell render.
	* Maybe have VCs conform to PresentationValueFormatting
* `syncReceipts` should avoid the full reload and use table view animated additions apis.
* `newReceiptFormViewControllerDidSaveReceipt` and `save` should interface with a store instead of the raw array

## ReceiptDetailViewController

* Should `receipt` be an optional?
	* Long Storyboard discussion here.
* `imageView` outlet lacks a name describing it's real use.
* More duplication of number formatters.
* Duplication of ui updating.
* share method needs to be broken down into different responsibilities.
	* action confirmation
	* network request
		* packaging up our unique payload
		* use the same post code with future calls.
		* `slackDescription` should not be in base mode.
	* handling network response
		* repetitive alert code in confirmation
			* are modal confirmations appropriate here?
		* lack of user disclosure of when something goes wrong, what went wrong.
		* Maybe consider a `Result<T>` type?
	* might want to consider a larger share history, share result, share retry.

## NewReceiptFormViewController

* Curious mix of using `photo` and the form view values to store the content be edited.
	* Does fix the problem of editing the raw model and then hitting cancel.
* Stack View layout has pros and cons.
	* Was painful to make, lots of use of priorities for hugging and resistance.
* New... class name does not suggest that this class also handles editing.
* `createView` method name might want to suggest the Nib source.
* viewDidLoad behaviors should be broken out into self documenting methods.
* More duplicative formatters.
* saveAction should be broken down.
	* Validators testes
	* user presentation considered.
* `updateDateTextFieldFromPicker` does nothing, remove it.
* Might consider wrapping UIImagePicker and returning a Result.
* Consider making local var to better express boolean math
* let hidePhotoRow = photo != nil
* let hideRemoveButtonRow = !hidePhotoRow
* addPhotoRow.isHidden = hidePhotoRow
* removePhotoRow.isHidden = hideRemoveButtonRow

## Receipt Model

* Remove `slackDescription`
* DRY up NSCoding related key strings.
* Consider making a new imageStore and storing UUIDs for the images to help with memory usage. Imaging 1000 Receipts, do we want all of their images in memory at the same time?
* Convert `NSDecimalNumber` to the newer `DecimalNumber`.
* Receipt.date could be Receipt.purchaseDate to be more descriptive about it's intention.

## ReceiptTableViewCell

* See cell discussion in `ReceiptsListViewController` above.
* How do we test auto layout resistance rules?

## ReceiptRemoteStore

* Should make new object for the responsibility into breaking down remote data into understandable data structures.
	* While many like to map right to core app models, it is often helpful to map to smaller objects and then map those to app models. Can make a BIG difference as new persistence systems are introduced (ala Core Data).
* similar data formatter duplication
* no more `try!`

## RandomRemoteStoreDataSource

Feel free to ignore this class, it's meant to fake a network response.

## DatePickerInputView

* Add private to hide outlets
* Rename createView()

## Big Refactors

Not recommended per say, but documenting for discussion:

* Convert Receipt to a value struct instead of a reference class
	* Would require a custom persistence path
	* Would change edit behavior assumptions. 

## Other Notes, Discussion Points:

* How do we test auto layout?
* How do we refactor auto layout?
