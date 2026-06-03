import { Controller, Get } from '@nestjs/common';
import { ApiOkResponse, ApiTags } from '@nestjs/swagger';

type HealthResponse = {
  status: 'ok';
  service: string;
  database: 'not_checked';
  redis: 'not_checked';
  timestamp: string;
};

@ApiTags('health')
@Controller('health')
export class HealthController {
  @Get()
  @ApiOkResponse({ description: 'API health status' })
  getHealth(): HealthResponse {
    return {
      status: 'ok',
      service: 'fap-api',
      database: 'not_checked',
      redis: 'not_checked',
      timestamp: new Date().toISOString(),
    };
  }
}
