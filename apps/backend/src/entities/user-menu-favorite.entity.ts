/**
 * @file src/entities/user-menu-favorite.entity.ts
 * @description 사용자별 메뉴 즐겨찾기 엔티티
 *
 * 초보자 가이드:
 * 1. ORGANIZATION_ID + USER_ID + MENU_CODE가 PK — 사용자당 메뉴 하나에 즐겨찾기 한 건
 * 2. SORT_ORDER는 즐겨찾기 표시 순서(10단위)
 * 3. USER_ID는 ISYS_USERS.USER_ID — 토큰이 USER_ID이므로 그대로 사용
 */
import {
  Entity,
  PrimaryColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity({ name: 'USER_MENU_FAVORITES' })
export class UserMenuFavorite {
  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId!: number;

  @PrimaryColumn({ name: 'USER_ID', type: 'varchar2', length: 20 })
  userId!: string;

  @PrimaryColumn({ name: 'MENU_CODE', type: 'varchar2', length: 100 })
  menuCode!: string;

  @Column({ name: 'SORT_ORDER', type: 'number', precision: 10, scale: 0, default: 0 })
  sortOrder!: number;

  @Column({ name: 'FOLDER_ID', type: 'number', precision: 15, scale: 0, nullable: true })
  folderId!: number | null;

  @CreateDateColumn({ name: 'CREATED_AT', type: 'timestamp' })
  createdAt!: Date;

  @Column({ name: 'CREATED_BY', type: 'varchar2', length: 50 })
  createdBy!: string;

  @UpdateDateColumn({ name: 'UPDATED_AT', type: 'timestamp' })
  updatedAt!: Date;

  @Column({ name: 'UPDATED_BY', type: 'varchar2', length: 50 })
  updatedBy!: string;
}
