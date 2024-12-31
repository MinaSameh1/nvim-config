local s = require('snippets.helpers')

return {
  s.s(
    { trig = 'expoldmongomodel', dscr = 'Express Mongoose Model' },
    s.fmt(
      [[import mongoose from "mongoose";

export interface {} {{}}

// WARN: This is deprecated, use
// `type {upper}Document = ReturnType<(typeof {upper})['hydrate']>;`
//  instead if you want the hydrated document type
export interface {upper}Document extends {upper}, mongoose.Document {{
  createdAt: Date;
  updatedAt: Date;
}}

const {upper}Schema = new mongoose.Schema<{upper}Document>({{}}, {{ timestamps: true }});

// WARN: Mongoose models no longer support passing document type.
export const {upper}Model = mongoose.model<{upper}Document>("{lower}", {upper}Schema);

export default {upper}Model;
      ]],
      {
        s.i(1, 'name'),
        lower = s.l(s.l._1:lower(), 1),
        upper = s.l(s.l._1:sub(1, 1):upper() .. s.l._1:sub(2, -1), 1),
      }
    )
  ),
  s.s(
    { trig = 'expmongomodel', dscr = 'Express Mongoose Model' },
    s.fmt(
      [[import mongoose from "mongoose";

export interface {} {{
  _id: mongoose.Types.ObjectId;
  createdAt: Date;
  updatedAt: Date;
}}

const {upper}Schema = new mongoose.Schema<{upper}>({{}}, {{ timestamps: true }});

export const {upper}Model = mongoose.model<{upper}>("{lower}", {upper}Schema);

// Just in case, but why would we need this type?
// export type {upper}Document = ReturnType<(typeof {upper}Model)["hydrate"]>;

export default {upper}Model;
]],
      {
        s.i(1, 'name'),
        lower = s.l(s.l._1:lower(), 1),
        upper = s.l(s.l._1:sub(1, 1):upper() .. s.l._1:sub(2, -1), 1),
      }
    )
  ),
  s.s(
    { trig = 'expoldmongorepo', dscr = 'Express Mongoose Repository' },
    s.fmt(
      [[import {{ FilterQuery, QueryOptions, ProjectionType }} from "mongoose";
import {{ {upper}Document, {upper}Model, {upper} }} from "../models";

export const {}Repository = {{
  findOne: (
    query: FilterQuery<{upper}Document>,
    options: QueryOptions<{upper}Document> | undefined = {{}}
  ) =>
    {upper}Model.findOne<{upper}>(query, options).lean().exec(),

  findById: (
    id: string,
    options: QueryOptions<{upper}Document> | undefined = {{}}
  ) =>
    {upper}Model.findById<{upper}>(id, options).lean().exec(),

  Create: (item: {upper}) => {upper}Model.create(item),

  find: (
    query: FilterQuery<{upper}Document>,
    limit = 10,
    skip = 0,
    options: QueryOptions<{upper}Document> | undefined = {{}},
    select: ProjectionType<{upper}Document> = {{}}
  ) =>
    {upper}Model.find<{upper}>(query, select, options)
      .limit(limit)
      .skip(skip)
      .sort({{ createdAt: -1 }})
      .lean()
      .exec(),

  updateOne: (query: FilterQuery<{upper}Document>, update: Partial<{upper}>) =>
    {upper}Model.findOneAndUpdate<{upper}>(query, update, {{ new: true }}).exec(),

  updateById: (id: string, update: Partial<{upper}>) =>
    {upper}Model.findByIdAndUpdate<{upper}>(id, update, {{ new: true }}).exec(),

  deleteOne: (query: FilterQuery<{upper}Document>) => {upper}Model.findOneAndDelete<{upper}>(query).exec(),

  deleteById: (id: string) => {upper}Model.findByIdAndDelete<{upper}>(id).exec()
}};
      ]],
      {
        s.i(1, 'name'),
        upper = s.l(s.l._1:sub(1, 1):upper() .. s.l._1:sub(2, -1), 1),
      }
    )
  ),
  s.s(
    { trig = 'expmongorepo', dscr = 'Express Mongoose Repository' },
    s.fmt(
      [[import {{ FilterQuery, QueryOptions, ProjectionType }} from "mongoose";
import {{ {upper}, {upper}Model }} from "../models";
import {{ ObjectId }} from "../../../utils";

export const {}Repository = {{
  findOne: (
    query: FilterQuery<{upper}>,
    options: QueryOptions<{upper}> | undefined = {{}}
  ) =>
    {upper}Model.findOne<{upper}>(query, options).lean().exec(),

  findById: (
    id: string,
    options: QueryOptions<{upper}> | undefined = {{}},
    select: ProjectionType<{upper}> = {{}}
  ) =>
    {upper}Model.findById(id, select, options).lean().exec(),

  Create: (item: Partial<Omit<{upper}, '_id' | 'createdAt' | 'updatedAt'>>) => {upper}Model.create(item),

  find: (
    query: FilterQuery<{upper}>,
    limit = 10,
    skip = 0,
    options: QueryOptions<{upper}> | undefined = {{}},
    select: ProjectionType<{upper}> = {{}}
  ) =>
    {upper}Model.find<{upper}>(query, select, options)
      .limit(limit)
      .skip(skip)
      .sort({{ createdAt: -1 }})
      .lean()
      .exec(),

  updateOne: (query: FilterQuery<{upper}>, update: Partial<{upper}>) =>
    {upper}Model.findOneAndUpdate<{upper}>(query, update, {{ new: true }}).exec(),

  updateById: (id: string, update: Partial<{upper}>, select: ProjectionType<{upper}> = {{}}) =>
    {upper}Model.findByIdAndUpdate<{upper}>(id, update, {{ new: true, lean: true }}).select(select).exec(),

  deleteOne: (query: FilterQuery<{upper}>) => {upper}Model.findOneAndDelete<{upper}>(query).exec(),

  deleteById: (id: string) => {upper}Model.findByIdAndDelete<{upper}>(id).exec(),

  filterSearch: (query: object) => {{
    const filter: FilterQuery<{upper}> = {{}}

    if("_id" in query) {{
      filter['_id'] = ObjectId(String(query._id).replace(/$|\\/, ''))
    }}

    return filter
  }}
}};
      ]],
      {
        s.i(1, 'name'),
        upper = s.l(s.l._1:sub(1, 1):upper() .. s.l._1:sub(2, -1), 1),
      }
    )
  ),
}
