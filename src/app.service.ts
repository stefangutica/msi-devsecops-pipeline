import { Injectable } from '@nestjs/common';

@Injectable()
export class AppService {
  getHello(): string {
    const apiKey = '550e8400-e29b-41d4-a716-446655440000';//test
    return 'Hello World!';
  }
}
