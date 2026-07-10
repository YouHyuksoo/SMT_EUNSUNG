/**
 * @file src/modules/auth/auth.dto.ts
 * @description 인증 관련 DTO 정의 (은성전장).
 *
 * 은성전장 로그인은 email이 아니라 ISYS_USERS.USER_ID 로 한다.
 * 프론트엔드는 기존 계약을 유지하기 위해 `email` 필드에 USER_ID를 담아 보낸다.
 */
import { IsNotEmpty, IsString, IsOptional } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class LoginDto {
  @ApiProperty({ description: '사용자 아이디(USER_ID)', example: 'ADMIN' })
  @IsString()
  @IsNotEmpty({ message: '아이디를 입력해주세요.' })
  email: string;

  @ApiProperty({ description: '비밀번호', example: '12351235' })
  @IsString()
  @IsNotEmpty({ message: '비밀번호를 입력해주세요.' })
  password: string;

  @ApiPropertyOptional({ description: '회사코드' })
  @IsOptional()
  @IsString()
  company?: string;

  @ApiPropertyOptional({ description: '사업장코드' })
  @IsOptional()
  @IsString()
  plant?: string;
}

export class RegisterDto {
  @ApiProperty({ description: '사용자 아이디(USER_ID)' })
  @IsString()
  @IsNotEmpty()
  email: string;

  @ApiProperty({ description: '비밀번호' })
  @IsString()
  @IsNotEmpty()
  password: string;

  @ApiPropertyOptional({ description: '이름' })
  @IsOptional()
  @IsString()
  name?: string;

  @ApiPropertyOptional({ description: '사원번호' })
  @IsOptional()
  @IsString()
  empNo?: string;

  @ApiPropertyOptional({ description: '부서' })
  @IsOptional()
  @IsString()
  dept?: string;

  @ApiPropertyOptional({ description: '회사코드' })
  @IsOptional()
  @IsString()
  company?: string;

  @ApiPropertyOptional({ description: '사업장코드' })
  @IsOptional()
  @IsString()
  plant?: string;
}
