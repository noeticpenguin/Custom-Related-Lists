/*
 * MultiselectController synchronizes the values of the hidden elements to the
 * SelectOption lists.

 * Adapted from Pat Patterson's excelent component here:
 * https://github.com/metadaddy-sfdc/Visualforce-Multiselect-Picklist

 */

public with sharing class CRL_MultiSelectCtrl {
	// SelectOption lists for public consumption
	public SelectOption[] leftOptionsCtrl { get; set; }
	public SelectOption[] rightOptionsCtrl { get; set; }

	// Parse &-separated values and labels from value and
	// put them in option
	private void setOptions(SelectOption[] options, String value) {
		options.clear();
		String[] parts = value.split('&');
		for (Integer i = 0; i < parts.size() / 2; i++) {
			options.add(new SelectOption(EncodingUtil.urlDecode(parts[i * 2], 'UTF-8'),
																	 EncodingUtil.urlDecode(parts[(i * 2) + 1], 'UTF-8')));
		}
	}

	// Backing for hidden text field containing the options from the
	// left list
	public String leftOptionsHidden {
		get;
		set {
			leftOptionsHidden = value;
			setOptions(leftOptionsCtrl, value);
		}
	}

	// Backing for hidden text field containing the options from the
	// right list
	public String rightOptionsHidden {
		get;
		set {
			rightOptionsHidden = value;
			setOptions(rightOptionsCtrl, value);
		}
	}
}