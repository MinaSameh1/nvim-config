local s = require('snippets.shorthands')
local l = require('luasnip.extras').l
local get_node_text = require('config.utils').get_node_text

require('snippets.javascript') -- Load js snippets

-- Needed for fancy snippets
local ts_utils_ok, ts_utils = pcall(require, 'nvim-treesitter.ts_utils')
if not ts_utils_ok then
  return {}
end

local function_q = vim.treesitter.query.parse(
  'typescript',
  -- (function_definition parameters: (parameters) @parms)
  [[
    [
        (function_declaration parameters: (formal_parameters) @parms)
    ] @fn
]]
)
-- This only matches returns that actually return something, so early return can still be used for
-- control flow!
local return_q =
  vim.treesitter.query.parse('typescript', '(return_statement) @ret')

--- Obtains list of parameter names for the next lua function and whether it returns something.
-- @param linenr Line number at which we start searching.
-- @return parms, ret where parms is a list of parameters, in the order that they appear in the
--         function and ret is truthy if the function ever returns something.
local function next_fun_parms(linenr)
  if not linenr then
    return
  end
  local bufnr = vim.api.nvim_get_current_buf()

  -- TODO: Doesn't work if we land inside of a comment block because that's a different
  -- "language".
  local root = ts_utils.get_root_for_position(linenr - 1, 0)
  if not root then
    return
  end

  for _, captures, _ in function_q:iter_matches(root, bufnr) do
    local sline = captures[1]:range()

    if sline >= linenr - 1 then
      local parms = {}
      for parm, node_type in captures[1]:iter_children() do
        -- Parameters are given via "name" nodes, other nodes might be comments etc.
        if node_type == 'name' then
          table.insert(parms, get_node_text(parm, bufnr))
        end
      end

      local returns = return_q:iter_matches(captures[2], bufnr)()
      return parms, returns
    end
  end
end

return {
  -- TODO: Fix this, needs better queries
  s.s('doc', {
    s.t({ '', '/**' }),
    s.t({ '', ' *' }),
    s.i(1, ' Function description.'),
    s.d(2, function(_, snip)
      local parms, ret = next_fun_parms(tonumber(snip.env.TM_LINE_NUMBER))
      -- checks if table is empty
      assert(parms or next(parms), 'Did not find a function!')

      local parm_nodes = {}
      for j, parm in ipairs(parms) do
        table.insert(parm_nodes, s.t({ '', '@param ' .. parm .. ' ' }))
        table.insert(parm_nodes, s.i(j, 'Parameter description.'))
      end

      if ret then
        table.insert(parm_nodes, s.t({ '', '@return ' }))
        table.insert(parm_nodes, s.i(#parms + 1, 'Return description.'))
      end

      table.insert(parm_nodes, s.t({ '', ' *' }))
      table.insert(parm_nodes, s.t({ '', ' */' }))
      return s.s(1, parm_nodes)
    end),
  }),
  s.s(
    'func',
    s.fmt(
      [[
    /**
      * @function {doc}
      * @description {}
      * @param {paramdoc}
      * @return {ret}
      */
    {} {} ({}): {} {{{}}}
    ]],
      {
        s.c(1, {
          s.t('function'),
          s.t('async function'),
          s.t('export function'),
          s.t('export async function'),
        }),
        s.i(2, 'name'),
        s.i(3, 'param'),
        paramdoc = s.i(4),
        s.i(5, 'return'),
        s.i(6, 'body'),
        s.i(7, 'description'),
        ret = s.f(s.copy, 5),
        doc = s.f(s.copy, 2),
      }
    )
  ),
  s.parse({
    trig = 'errimpl',
    description = 'Adds a throw err with message',
  }, 'throw new Error("${1:Not Implemented}");'),
  s.s(
    'todo',
    s.fmt([[ // TODO: {date} {}]], {
      date = s.f(function()
        return os.date('%D - %H:%M')
      end),
      s.i(1),
    })
  ),
  -- Create express controller snippet
  s.s(
    { trig = 'exprouter', dscr = 'Express Router' },
    s.fmt(
      [[
  import {{ Router }} from "express";

  const {name}Router = Router();

  {name}Router.get("/", {controller});

  export default {}Router;
  ]],
      {
        s.i(1),
        name = s.f(s.copy, 1),
        controller = s.i(2, 'controller'),
      }
    )
  ),
  s.s(
    {
      trig = 'expcont',
      dscr = 'Express Controller with choice for controller shape',
    },
    s.fmt(
      [[
  /**
   * @function {}
   * @description {}
   * @param {{Request}} req Express Request
   * @param {{Response}} res Express Response
   * @param {{NextFunction}} next Express Next Function
   */
  export {} {{
    try {{
      {}
    }} catch (err) {{
      next(err);
    }}
  }}
  ]],
      {
        s.i(1),
        s.i(2),
        s.c(3, {
          s.fmt('const {name}: ExpressFunc = async (req, res, next) =>', {
            name = s.i(1, 'name'),
          }),
          s.fmt(
            'const {name} = async (req: Request, res: Response, next: NextFunction) =>',
            {
              name = s.i(1, 'name'),
            }
          ),
          s.fmt(
            'async function {name}(req: Request, res: Response, next: NextFunction)',
            {
              name = s.i(1, 'name'),
            }
          ),
        }),
        s.i(4),
      }
    )
  ),
  s.s(
    { trig = 'expmongomodel', dscr = 'Express Mongoose Model' },
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
        upper = s.l(s.l._1:sub(1, 1):upper() .. l._1:sub(2, -1), 1),
      }
    )
  ),
  s.s(
    { trig = 'expmongorepo', dscr = 'Express Mongoose Repository' },
    s.fmt(
      [[import {{ FilterQuery, QueryOptions, ProjectionType }} from "mongoose";
import {{ {upper}Document, {upper}Model, {upper} }} from "../models";

export const {}Repository = {{
  findOne: (
    query: FilterQuery<{upper}Document>,
    options: QueryOptions<{upper}Document> | undefined = {{}}
  ) =>
    {upper}Model.findOne(query, options).lean().exec(),

  findById: (
    id: string,
    options: QueryOptions<{upper}Document> | undefined = {{}}
  ) =>
    {upper}Model.findById(id, options).lean().exec(),

  Create: (item: {upper}) => {upper}Model.create(item),

  find: (
    query: FilterQuery<{upper}Document>,
    limit = 10,
    skip = 0,
    options: QueryOptions<{upper}Document> | undefined = {{}},
    select: ProjectionType<{upper}Document> = {{}}
  ) =>
    {upper}Model.find(query, select, options)
      .limit(limit)
      .skip(skip)
      .sort({{ createdAt: -1 }})
      .lean()
      .exec(),

  updateOne: (query: FilterQuery<{upper}Document>, update: Partial<{upper}>) =>
    {upper}Model.findOneAndUpdate(query, update, {{ new: true }}),

  updateById: (id: string, update: Partial<{upper}>) =>
    {upper}Model.findByIdAndUpdate(id, update, {{ new: true }}),

  deleteOne: (query: FilterQuery<{upper}Document>) => {upper}Model.findOneAndDelete(query),

  deleteById: (id: string) => {upper}Model.findByIdAndDelete(id)
}};
      ]],
      {
        s.i(1, 'name'),
        upper = s.l(s.l._1:sub(1, 1):upper() .. l._1:sub(2, -1), 1),
      }
    )
  ),
  s.parse('clgv', 'console.log("${1:value} >>", ${2:value});'),
  s.parse('clg', 'console.log("${1:value}");'),
  s.s(
    { trig = 'nestcontroller', dscr = 'NestJS Controller' },
    s.fmt(
      [[
import {{ Controller }} from '@nestjs/common'
import {{ ApiTags }} from '@nestjs/swagger'

@Controller('{tag}')
@ApiTags('{tag}')
export class {name}Controller {{

}}
]],
      {
        name = s.i(1, 'name'),
        tag = l(l._1:lower(), 1),
      }
    )
  ),
  s.s(
    { trig = 'nestprovider', dscr = 'NestJS Provider' },
    s.fmt(
      [[
import {{ Injectable, Logger }} from '@nestjs/common';

@Injectable()
export class {}Service {{
  private readonly logger = new Logger({service}Service.name);

  {}

}}
]],
      {
        s.i(1),
        s.i(2),
        service = s.f(s.copy, 1),
      }
    )
  ),
  s.s(
    { trig = 'nestmodule', dscr = 'NestJS Module' },
    s.fmt(
      [[
import {{ Module }} from '@nestjs/common';

@Module({{
  imports: [{imports}],
  controllers: [{controllers}],
  providers: [{providers}],
  exports: [{exports}]
}})
export class {name}Module {{}}
]],
      {
        imports = s.i(1, 'imports'),
        controllers = s.i(2, 'controllers'),
        providers = s.i(3, 'providers'),
        exports = s.i(4, 'exports'),
        name = s.i(5, 'name'),
      }
    )
  ),
  s.s(
    { trig = 'nestpipe', dscr = 'NestJS Pipe' },
    s.fmt(
      [[
import {{ Injectable, PipeTransform, ArgumentMetadata, BadRequestException }} from '@nestjs/common';

@Injectable()
export class {PipeName}Pipe implements PipeTransform {{
  transform(value: any, metadata: ArgumentMetadata) {{
    {logic}
    return value;
  }}
}}
]],
      {
        PipeName = s.i(1, 'PipeName'),
        logic = s.i(2, '// Add your logic here'),
      }
    )
  ),
  s.s(
    { trig = 'nestguard', dscr = 'NestJS Guard' },
    s.fmt(
      [[
import {{ Injectable, CanActivate, ExecutionContext }} from '@nestjs/common';

@Injectable()
export class {GuardName} implements CanActivate {{
  canActivate(context: ExecutionContext) {{
    const request = context.switchToHttp().getRequest();
    {logic}
    return true;
  }}
}}
]],
      {
        GuardName = s.i(1, 'GuardName'),
        logic = s.i(2, '// Add your logic here'),
      }
    )
  ),
  s.s(
    { trig = 'nestmetadata', dscr = 'NestJS Metadata Decorator' },
    s.fmt(
      [[import {{ SetMetadata }} from '@nestjs/common';

export const {name} = (...args: string[]) => SetMetadata('{lower}', args);
    ]],
      {
        name = s.i(1, 'name'),
        lower = s.l(
          s.l._1:sub(1, 1)
            .. s.l._1:sub(2, -1):gsub('%u', function(c)
              return '_' .. c:lower()
            end),
          1
        ),
      }
    )
  ),
  s.s(
    { trig = 'nestparamdecorator', dscr = 'NestJS Param Decorator' },
    s.fmt(
      [[import {{ ExecutionContext, createParamDecorator }} from '@nestjs/common'
import type {{ Request }} from 'express'

/**
 *  @description {desc}
 *  @returns {returns}
 */
export const {name} = createParamDecorator(
  (data = null, ctx: ExecutionContext) => {{
    const request = ctx.switchToHttp().getRequest<Request>()
    {body}
  }},
)]],
      {
        name = s.i(1, 'name'),
        desc = s.i(2, 'description'),
        returns = s.i(3, 'return'),
        body = s.i(4, 'body'),
      }
    )
  ),
}
