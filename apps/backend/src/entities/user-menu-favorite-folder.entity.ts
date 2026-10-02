/** 조직·사용자별 1단계 즐겨찾기 폴더. ID는 Oracle SEQUENCE로 채번한다. */
import { Entity, PrimaryColumn, Column, CreateDateColumn, UpdateDateColumn } from 'typeorm';

@Entity({ name: 'USER_MENU_FAVORITE_FOLDERS' })
export class UserMenuFavoriteFolder {
  @PrimaryColumn({ name: 'ID', type: 'number', precision: 15, scale: 0 })
  id!: number;

  @Column({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId!: number;

  @Column({ name: 'USER_ID', type: 'varchar2', length: 20 })
  userId!: string;

  @Column({ name: 'NAME', type: 'varchar2', length: 100 })
  name!: string;

  @Column({ name: 'SORT_ORDER', type: 'number', precision: 15, scale: 0 })
  sortOrder!: number;

  @CreateDateColumn({ name: 'CREATED_AT', type: 'timestamp' })
  createdAt!: Date;

  @UpdateDateColumn({ name: 'UPDATED_AT', type: 'timestamp' })
  updatedAt!: Date;
}
