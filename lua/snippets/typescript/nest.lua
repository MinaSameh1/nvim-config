local s = require('snippets.helpers')

return {
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
        tag = s.l(s.l._1:lower(), 1),
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
  {}
}})
export class {name}Module {{}}
]],
      {
        name = s.i(1, 'name'),
        s.c(2, {
          s.fmt(
            [[
  imports: [{imports}],
  controllers: [{controllers}],
  providers: [{providers}],
  exports: [{exports}]
          ]],
            {

              imports = s.i(1, 'imports'),
              controllers = s.i(2, 'controllers'),
              providers = s.i(3, 'providers'),
              exports = s.i(4, 'exports'),
            }
          ),
          s.fmt(
            [[
  imports: [{imports}],
  providers: [{providers}],
  exports: [{exports}]
          ]],
            {

              imports = s.i(1, 'imports'),
              providers = s.i(2, 'providers'),
              exports = s.i(3, 'exports'),
            }
          ),
          s.fmt(
            [[
  imports: [{imports}],
  controllers: [{controllers}],
  providers: [{providers}],
          ]],
            {

              imports = s.i(1, 'imports'),
              controllers = s.i(2, 'controllers'),
              providers = s.i(3, 'providers'),
            }
          ),
        }),
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

export const {name} = (...args: string[]) => SetMetadata('{remove_space}', args);
    ]],
      {
        name = s.i(1, 'name'),
        remove_space = s.l(
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
    { trig = 'nesttypeormrepository', dscr = 'NestJS TypeORM Repository' },
    s.fmt(
      [[import {{ Injectable }} from '@nestjs/common';
import {{ Repository, DataSource }} from 'typeorm';
import {{ {copy} }} from '../entity/{lower}.entity';

@Injectable()
export class {copy}Repository extends Repository<{copy}> {{

  constructor(private dataSource: DataSource) {{
    super({entity}, dataSource.createEntityManager());
  }}

  findByentity(name: string) {{
    return this.findOne({{ where: {{ name }} }});
  }}
}}
]],
      {
        entity = s.i(1, 'entity'),
        lower = s.l(s.l._1:lower(), 1),
        copy = s.f(s.copy, 1),
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
  s.s(
    { trig = 'nesttest', dscr = 'NestJS Basic Test structure' },
    s.fmt(
      [[import {{ Test, TestingModule }} from '@nestjs/testing'

describe('{test}', () => {{
  let service: {service};

  beforeEach(async () => {{
    const module: TestingModule = await Test.createTestingModule({{
      imports: [],
      providers: [{servicename}],
    }}).compile();

    service = module.get<{service}>({service});
  }});

  it('should be defined', () => {{
    expect(service).toBeDefined()
  }});
}})]],
      {
        test = s.i(1, 'test'),
        servicename = s.i(2, 'servicename'),
        service = s.f(s.copy, 2),
      }
    )
  ),
}
