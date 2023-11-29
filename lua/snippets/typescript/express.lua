local s = require('snippets.helpers')

return {
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
    { trig = 'expcrudcont', dscr = 'Express Crud Controller' },
    s.fmt(
      [[import {{ NextFunction, Request, Response }} from "express";
import {{ ErrorMessage }} from "../../../../assets/errors";
import {{ HttpStatus }} from "../../../../assets/httpCodes";
import {{ {repo} }} from "../../repositories";

export async function Create(req: Request, res: Response, next: NextFunction) {{
  try {{
    const data = await {repo}.Create(req.body);

    if (!data)
      return res
        .status(HttpStatus.CONFLICT)
        .json({{ message:  ErrorMessage.SOMETHING_WENT_WRONG }});
    return res.status(HttpStatus.CREATED).json({{ data }});
  }} catch (err) {{
    next(err);
  }}
}}

export async function List(
  req: Request,
  res: Response,
  next: NextFunction
) {{
  try {{
    const data = await {}.find(
      {repo}.filterSearch(req.query),
      req.limit,
      req.skip,
      undefined,
      {{}}
    );
    if (!data) {{
      res
        .status(HttpStatus.NO_CONTENT)
        .json({{ message: ErrorMessage.NO_CONTENT }});
    }}
    res.send({{ data, length: data.length }});
  }} catch (error) {{
    next(error);
  }}
}};

export async function One(
  req: Request,
  res: Response,
  next: NextFunction
) {{
  try {{
    const Id = req.params.id;
    const data = await {repo}.findById(Id);

    if (!data)
      res
        .status(HttpStatus.NO_CONTENT)
        .json({{ message: ErrorMessage.NO_CONTENT }});
    res.send({{ data }});
  }} catch (error) {{
    next(error);
  }}
}};

export async function Update (
  req: Request,
  res: Response,
  next: NextFunction
) {{
  try {{
    const Id = req.params.id;
    const data = await {repo}.updateById(
      Id,
      req.body
    );
    if (!data)
      return res
        .status(HttpStatus.BAD_REQUEST)
        .json({{ message: ErrorMessage.NO_RESOURCE_FOUND }});
    return res
      .status(HttpStatus.OK)
      .json({{ data }});
  }} catch (error) {{
    next(error);
  }}
}};

export async function Delete(
  req: Request,
  res: Response,
  next: NextFunction
) {{
  try {{
    const Id = req.params.id;
    const data = await {repo}.deleteById(Id);
    if (!data) {{
      return res
        .status(HttpStatus.NOT_FOUND)
        .json({{ message: ErrorMessage.NO_RESOURCE_FOUND }});
    }}
    return res
      .status(HttpStatus.OK)
      .send({{ message: ErrorMessage.SUCCESS_ACTION }});
  }} catch (error) {{
    next(error);
  }}
}};
    ]],
      {
        s.i(1, 'name'),
        repo = s.f(s.copy, 1),
      }
    )
  ),
  s.s(
    { trig = 'expcrudrouter', dscr = 'ExpressJS crud Router' },
    s.fmt(
      [[
import * as Controller from '../controllers/{cont}'
import {{ Router }} from "express";
import {{ isObjectId }} from "../../../../utils";
import {{
  Log,
  LogEverything,
  verifyAdminOnly,
  verifyParams
}} from "../../../../middlewares";

const {router}Router = Router();

{name}Router.get("/", Controller.List);
{name}Router.get("/:id", verifyParams(["id"], isObjectId), Controller.One);

{name}Router.patch(
  "/:id",
  LogEverything,
  verifyAdminOnly,
  verifyParams(["id"], isObjectId),
  Controller.Update
);

{name}Router.post("/", Log, Controller.Create);

{name}Router.delete(
  "/:id",
  Log,
  verifyAdminOnly,
  verifyParams(["id"], isObjectId),
  Controller.Delete
);

export default {name}Router;
]],
      {
        router = s.i(1),
        cont = s.i(2),
        name = s.f(s.copy, 1),
      }
    )
  ),
}
