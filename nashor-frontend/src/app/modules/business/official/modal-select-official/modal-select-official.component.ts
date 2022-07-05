import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Subject, takeUntil } from 'rxjs';
import { OfficialService } from '../official.service';
import { Official } from '../official.types';
import { ModalSelectOfficialService } from './modal-select-official.service';

@Component({
  selector: 'app-modal-select-official',
  templateUrl: './modal-select-official.component.html',
})
export class ModalSelectOfficialComponent implements OnInit {
  id_official: string = '';

  private _unsubscribeAll: Subject<any> = new Subject<any>();

  listOfficial: Official[] = [];
  selectOfficialForm!: FormGroup;

  constructor(
    @Inject(MAT_DIALOG_DATA) public _data: any,
    private _formBuilder: FormBuilder,
    private _officialService: OfficialService,
    private _modalSelectOfficialService: ModalSelectOfficialService
  ) {}

  ngOnInit(): void {
    /**
     * get the list of official
     */
    this._officialService
      .queryRead('*')
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((_officials: Official[]) => {
        this.listOfficial = _officials;
      });
    /**
     * form
     */
    this.selectOfficialForm = this._formBuilder.group({
      id_official: ['', [Validators.required]],
    });
  }
  /**
   * patchForm
   */
  patchForm(): void {
    this.selectOfficialForm.patchValue({
      id_official: this.selectOfficialForm.getRawValue().id_official,
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
    this.id_official = this.selectOfficialForm.getRawValue().id_official;
    this.patchForm();
  }
  /**
   * closeModalSelectOfficial
   */
  closeModalSelectOfficial(): void {
    this._modalSelectOfficialService.closeModalSelectOfficial();
  }
}
