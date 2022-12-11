import { FOLDER_ID, CHILDREN_ID } from "./Constants";

function deleteItem(tree, id) {
  function getNode(node, i) {
    if (node.id === id) {
      index = i;
      return true;
    }
    if (Array.isArray(node.children) && node.children.some(getNode)) {
      if (~index) {
        node.children.splice(index, 1);
        index = -1;
      }
      return true;
    }
  }

  let index = -1;
  [tree].some(getNode);
  return tree;
};

function newItemName(itemType) {
  return itemType === FOLDER_ID ? "New Goal" : "New Key Result";
}

function newItem(itemType) {
  const item =
    itemType === FOLDER_ID
      ? {
        id: `root-${Date.now()}`,
        title: newItemName(itemType),
        children: [],
        collapsed: false,
      }
      : {
        id: `${Date.now()}`,
        leaf: true,
        title: newItemName(itemType),
      };
  return item;
};

function renameItem(tree, id, _) {

  const renamable = _.findDeep(tree, (item) => item.id === id, {
    childrenPath: CHILDREN_ID,
  });
  const response = prompt("Please rename", renamable.value.title);

  if (response === "") {
    return;
  }
  renamable.value.title = response;

  return _.mapDeep(
    tree,
    (item) =>
      item.id === id
        ? {
          ...item,
          ...renamable.value,
        }
        : item,
    { childrenPath: CHILDREN_ID }
  )
}

function addItem(tree, itemType, active, _) {
  const newItemCreated = newItem(itemType);

  const newTree = _.mapDeep(tree, (item) => {
    const cloneItem = Object.assign({}, item);
    if (cloneItem) {
      if (cloneItem.id === active.id && cloneItem.children) {
        cloneItem.children.push(newItemCreated);
      }
    }
    return cloneItem;
  });

  return newTree;
};

export { deleteItem, renameItem, addItem };