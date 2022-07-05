import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Subject, takeUntil } from 'rxjs';
import { ItemCategoryService } from '../item-category.service';
import { ItemCategory } from '../item-category.types';
import { ModalSelectItemCategoryService } from './modal-select-item-category.service';

@Component({
  selector: 'app-modal-select-item-category',
  templateUrl: './modal-select-item-category.component.html',
})
export class ModalSelectItemCategoryComponent implements OnInit {
  id_item_category: string = '';

  private _unsubscribeAll: Subject<any> = new Subject<any>();

  listItemCategory: ItemCategory[] = [];
  selectItemCategoryForm!: FormGroup;

  constructor(
    @Inject(MAT_DIALOG_DATA) public _data: any,
    private _formBuilder: FormBuilder,
    private _itemCategoryService: ItemCategoryService,
    private _modalSelectItemCategoryService: ModalSelectItemCategoryService
  ) {}

  ngOnInit(): void {
    /**
     * get the list of itemCategory
     */
    this._itemCategoryService
      .queryRead('*')
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((_itemCategorys: ItemCategory[]) => {
        this.listItemCategory = _itemCategorys;
      });
    /**
     * form
     */
    this.selectItemCategoryForm = this._formBuilder.group({
      id_item_category: ['', [Validators.required]],
    });
  }
  /**
   * patchForm
   */
  patchForm(): void {
    this.selectItemCategoryForm.patchValue({
      id_item_category:
        this.selectItemCategoryForm.getRawValue().id_item_category,
    });
  }
  /**
   * On destroy
   */
  ngOnDestroy(): void {
    /**
     * Unsubscribe from all subscriptions
     */
    this._unsubscribeAll.next(0);
    this._unsubscribeAll.complete();
  }
  /**
   * changeSelect
   */
  changeSelect(): void {
    this.id_item_category =
      this.selectItemCategoryForm.getRawValue().id_item_category;
    this.patchForm();
  }
  /**
   * closeModalSelectItemCategory
   */
  closeModalSelectItemCategory(): void {
    this._modalSelectItemCategoryService.closeModalSelectItemCategory();
  }
}
