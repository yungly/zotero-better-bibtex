When /^I import (\d+) references from (['"])([^\2]+)\2$/ do |n, quote, json|
  imported = execute(
    timeout: 30,
    args: { filename: File.expand_path(File.join(File.dirname(__FILE__), '../../test/fixtures', json)) },
    script: """
      var file = Components.classes['@mozilla.org/file/local;1'].createInstance(Components.interfaces.nsILocalFile);
      file.initWithPath(args.filename);

      Zotero.debug('{better-bibtex} starting import at ' + new Date());
      yield Zotero_File_Interface.importFile(file, false);
      Zotero.debug('{better-bibtex} import finished at ' + new Date());

      var items = yield Zotero.Items.getAll(0, false, false, true);
      Zotero.debug('{better-bibtex} found ' + items.length + ' items');
      return items.length;
    """
  )
  expect(imported).to eq(Integer(n))
end

Then /^the library should have (\d+) references/ do |n|
  library = execute("""
      var items = yield Zotero.Items.getAll(0, false, false, true);
      return items.length;
    """
  )
  expect(library).to eq(Integer(n))
end
