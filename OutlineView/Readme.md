Outline View
============

This example features a view-based source list which shows a list of books. When the books are selected, the detail is shown to the right.

Bindings are used to display the data in the UI.

Also check the [DragNDropOutlineView](https://developer.apple.com/library/mac/samplecode/DragNDropOutlineView) for reference.


Screenshot
----------

![screenshot](https://raw.github.com/besi/mac-quickies/master/OutlineView/screenshot.png)


Setup in Interface Builder
--------------------------

The binding is setup in Interface builder

- For the movies add an Object and set its class to `NSMutableArray`.
- Add a Tree Controller and set the newly created `movies` object as its content connection.
- Setup the Tree Controller so set the Children KeyPath to `children` and the leaf KeyPath to `isLeaf`. The `Book` class always returns `YES` for `isLeaf`.
- Bind the **Table Column** of the `NSOutlineView` to the **Tree Controller** with the **Controller Key** of `arrangedObjects`.
- Bind the text field of the given cell (`DataCell`) to **Table Cell View** with the **Model Key Path** of `objectValue.title` which has to correspond with the data, that the **Tree Controller** is provided with.
    
- Despite the binding some things need to be set in code to achieve the following:

    - Tell the `NSOutlineView` which cell to use
    - Prevent the user from selecting the header cell
    - Tell the `NSOutlineView` whether a given note should be displayed as a header cell so that **Show/Hide** is shown rather than the disclosure indicator.

- Finally bind the text field's values to the **Tree Controller** with the **Controller Key** of `selection` and the **Model Key Path** of `title / author`.