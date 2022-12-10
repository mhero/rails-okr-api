export const FOLDER_ID = "folder";
export const CHILDREN_ID = "children";
export const ROOT_ID = "root-0"

export const INITIAL_TREE_STATE = {
  active: null,
  tree: {
    title: "OKR tree",
    id: ROOT_ID,
    children: [],
    collapsed: false,
  },
  collapsed: false, // start with unmodified tree
};

