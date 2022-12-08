import initialTree from "./InitialTree";

export const FOLDER_ID = "folder";
export const CHILDREN_ID = "children";

export const initialState = {
  active: null,
  tree: {
    ...initialTree,
  },
  collapsed: false, // start with unmodified tree
};