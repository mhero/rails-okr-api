export const FOLDER_ID = "folder";
export const CHILDREN_ID = "children";

export const initialState = {
  active: null,
  tree: {
    title: "OKR tree",
    id: "root-0",
    children: [],
    collapsed: false,
  },
  collapsed: false, // start with unmodified tree
};

